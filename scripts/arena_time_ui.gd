extends CanvasLayer


@export var arena_time_manager: Node
@onready var label = %Label


func _process(delta):
	if arena_time_manager == null: return
	
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_timer(time_elapsed)


func format_timer(seconds: int) -> String:
	var minutes: int = int(seconds / 60.0)
	var remaining_seconds: int = seconds % 60
	return "%d:%02d" % [minutes, remaining_seconds]
