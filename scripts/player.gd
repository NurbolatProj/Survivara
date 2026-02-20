extends CharacterBody2D

@onready var health_component = $HealthComponent
@onready var grace_period = $GracePeriod
@onready var progress_bar = $ProgressBar
@onready var ability_manager = $AbilityManager
@onready var animated_sprite_player = $AnimatedSpritePlayer
@onready var movement_component: Node = $MovementComponent

@export var health_regen: int = 1

var base_speed = 0
var enemies_colliding = 0
var enemy_damage: int = 0

func _ready():
	base_speed = movement_component.max_speed
	health_component.died.connect(on_died)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_increased.connect(on_health_increased)
	Global.ability_upgrade_added.connect(on_ability_upgrade_added)
	health_update()

func _process(_delta):
	var direction = movement_vector().normalized() # movement_vector не будет пересекать true(значение: 1) с помощю .normalized()
		
	velocity = movement_component.accelerate_to_direction(direction)
	move_and_slide()
	
	if direction.x != 0 || direction.y != 0:
		animated_sprite_player.play("run")
	else:
		animated_sprite_player.play('idle')
	
	var face_sign = sign(direction.x)
	if face_sign != 0:
		animated_sprite_player.scale.x = face_sign 

func movement_vector():
	var movement_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")  # Егер A дегенды басса move_left true болады, ал move_right болса false болады. Else: (баскаша) дал сондай.
	var movement_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x, movement_y)
	
func check_if_gamaged():
	if enemies_colliding == 0 || !grace_period.is_stopped():
		return
	health_component.take_damage(enemy_damage)
	grace_period.start()
	
func health_update():
	progress_bar.value = health_component.get_health_value()

func _on_player_hurt_box_area_entered(area):
	enemy_damage = area.enemy_damage()
	enemies_colliding += 1
	check_if_gamaged()

func _on_player_hurt_box_area_exited(area):
	enemies_colliding -= 1

func on_died():
	queue_free()

func on_health_decreased():
	$AudioStreamPlayer2D.play()
	Global.player_damaged.emit()
	health_update()
	
func on_health_increased():
	health_update()

func _on_grace_period_timeout():
	check_if_gamaged()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade is NewAbility:
		var new_ability = upgrade as NewAbility
		ability_manager.add_child(new_ability.new_ability_scene.instantiate())
	elif upgrade.id == "move_speed":
		movement_component.max_speed = base_speed + \
		(base_speed * current_upgrades["move_speed"]["quantity"] * 0.1)


func _on_health_regen_timer_timeout() -> void:
	var health_regen_bonus = MetaProgression.get_upgrade_quantity("health_regeneration")
	health_component.take_heal(health_regen + health_regen_bonus)

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")
func _on_pause_button_pressed() -> void:
	add_child(pause_menu_scene.instantiate())
