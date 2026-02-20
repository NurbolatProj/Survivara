extends Control

@onready var language_selector : OptionButton = %LanguageSelector

var flag_us = preload("res://ui/flags/us.png")
var flag_ru = preload("res://ui/flags/ru.png")
var flag_kz = preload("res://ui/flags/kz.png")


func _ready():
	language_selector.clear()

	language_selector.add_icon_item(flag_us, "English", 0)
	language_selector.add_icon_item(flag_ru, "Русский", 1)
	language_selector.add_icon_item(flag_kz, "Қазақша", 2)

	language_selector.item_selected.connect(_on_language_selected)

	update_selector()


func update_selector():
	var map = {
		"en": 0,
		"ru": 1,
		"kk": 2
	}

	language_selector.select(map.get(LanguageManager.current_locale, 0))


func _on_language_selected(index):
	match index:
		0:
			LanguageManager.set_language("en")
		1:
			LanguageManager.set_language("ru")
		2:
			LanguageManager.set_language("kk")
