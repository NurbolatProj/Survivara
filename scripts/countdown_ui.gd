extends CanvasLayer

signal finished

@onready var label = $Label

func start_countdown():
	show()
	await countdown()
	hide()
	finished.emit()


func countdown():
	label.text = "3"
	await get_tree().create_timer(1).timeout
	
	label.text = "2"
	await get_tree().create_timer(1).timeout
	
	label.text = "1"
	await get_tree().create_timer(1).timeout
