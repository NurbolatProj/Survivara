extends Node

var current_locale : String = "en"

func _ready():
	load_language()

func set_language(locale: String):
	current_locale = locale
	TranslationServer.set_locale(locale)
	save_language()

func save_language():
	var config = ConfigFile.new()
	config.set_value("settings", "language", current_locale)
	config.save("user://settings.cfg")

func load_language():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		current_locale = config.get_value("settings", "language", "en")

	TranslationServer.set_locale(current_locale)
