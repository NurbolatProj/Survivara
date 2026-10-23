extends CanvasLayer

@onready var base = $Base
@onready var stick = $Base/Stick

var is_active := true


func _ready():
	base.modulate.a = 0
	create_tween().tween_property(base, "modulate:a", 0.6, 0.5)
	play_demo()


func play_demo():
	while is_active:
		await move_stick(Vector2(60, 0))
		await move_stick(Vector2(-60, 0))
		await move_stick(Vector2(0, -60))
		await move_stick(Vector2(0, 60))


func move_stick(my_offset: Vector2):
	if not is_active:
		return
	
	var tween = create_tween()
	tween.tween_property(stick, "position", my_offset, 0.4)
	await tween.finished
	
	var tween_back = create_tween()
	tween_back.tween_property(stick, "position", Vector2.ZERO, 0.4)
	await tween_back.finished


func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		stop()


func stop():
	is_active = false
	
	var tween = create_tween()
	tween.tween_property(base, "modulate:a", 0, 0.3)
	await tween.finished
	
	queue_free()
