extends CanvasLayer

var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")

func _on_options_button_pressed() -> void:
	# приготовка для спавна сцены
	var options_instance = options_menu_scene.instantiate()
	add_child(options_instance)

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_upgrades_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func _on_touch_screen_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")
