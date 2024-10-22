class_name LevelPrompt
extends Control

signal upgrade

# upgrade_type arguments are binded through the editor
# 0: damage
# 1: health

func _on_button_pressed(upgrade_type: int) -> void:
	upgrade.emit(upgrade_type)
	set_visible(false)
