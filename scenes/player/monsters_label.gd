class_name MonstersLabel
extends Label

@export var animation_player: AnimationPlayer

func show_label() -> void:
	set_visible(true)
	animation_player.play('smooth_alpha')


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	set_visible(false)
