extends CanvasLayer

@onready var window_mode_button: Button = %WindowModeButton
@onready var window_mode_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/WindowModeContainer/Label

@onready var sfx_slider: HSlider = %SFXSlider
@onready var music_slider: HSlider = %MusicSlider

@onready var virtual_joystick: Node2D = $"Virtual Joystick"

var is_mobile := false
var is_left_handed := false


func _ready() -> void:
	is_mobile = OS.has_feature("mobile")
	update_options()


func update_options():
	if is_mobile:
		# 📱 телефон
		window_mode_label.text = tr("str_Hand_Mode")
		update_hand_text()
	else:
		# 💻 ПК
		window_mode_label.text = tr("str_Window_Mode")

		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode_button.text = tr("str_Fullscreen")
		else:
			window_mode_button.text = tr("str_Windowed")

	sfx_slider.value = get_volume_percent(2)
	music_slider.value = get_volume_percent(1)


func update_hand_text():
	if is_left_handed:
		window_mode_button.text = tr("str_Left_Hand")
	else:
		window_mode_button.text = tr("str_Right_Hand")


func get_volume_percent(bus_index: int):
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


# 🔥 ОДНА кнопка — разное поведение
func _on_window_mode_button_pressed() -> void:
	if is_mobile:
		# 📱 переключаем левша / правша
		is_left_handed = !is_left_handed

		if virtual_joystick:
			if is_left_handed:
				virtual_joystick.position.x = 100
			else:
				virtual_joystick.position.x = 500

		update_hand_text()

	else:
		# 💻 обычный window mode
		var mode = DisplayServer.window_get_mode()
		
		if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
		update_options()


func _on_sfx_slider_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(2, volume_db)


func _on_music_slider_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(1, volume_db)


func _on_back_button_pressed() -> void:
	queue_free()
