class_name Fireball
extends AnimatedSprite2D

@export var damage_coeficient: float = 0.5
var damage: int = 0

func _ready() -> void:
	play('default')


func set_damage(player_damage: float) -> void:
	damage = int(player_damage * damage_coeficient)
