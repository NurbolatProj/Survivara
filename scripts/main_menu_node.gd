extends Node

@onready var play_button = $MainMenu/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PlayButton
@onready var quit_button = $MainMenu/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/QuitButton

var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/choose_map.tscn")


func _on_wardrobe_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func _on_options_button_pressed() -> void:
	add_child(options_menu_scene.instantiate())


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")
