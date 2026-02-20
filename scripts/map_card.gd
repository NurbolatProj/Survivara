extends Control


func _on_choose_map_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")
