class_name TimerLabel
extends Label

@export var timer: Timer
var seconds: int = 0
var minutes: int = 0

func _on_timer_timeout() -> void:
	seconds += 1
	if seconds >= 60:
		minutes += 1
		seconds = 0
	
	# Leading zero problems...
	if seconds <= 9:
		set_text('Survived ' + str(minutes) + ':0' + str(seconds))
	else:
		set_text('Survived ' + str(minutes) + ':' + str(seconds))
