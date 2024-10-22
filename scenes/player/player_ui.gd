class_name PlayerUI
extends Control

@export var health_label: Label
@export var experience_label: Label

var player: Player

func update_ui() -> void:
	health_label.set_text('Health: ' + str(player.hp) + ' / ' + str(player.max_hp))
	experience_label.set_text('Experience: ' + str(player.experience) + ' / ' + str(player.required_exp))
