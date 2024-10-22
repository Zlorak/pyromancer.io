class_name MonsterResource
extends Resource

@export_group('Stats')
var level: int
var max_hp: int
var hp: int
var attack: int
@export var speed: int
@export var experience: int
@export_group('Stats Coeficients')
@export var max_hp_multiplier: float
@export var max_hp_base: int
@export var attack_multiplier: float
@export var attack_base: int
@export_group('Resources')
@export var attack_frame: int
@export var hurt_frame: int
@export var animated_sprites: SpriteFrames
@export var collision_offset: Vector2
@export var body_shape: Shape2D
@export var attack_shape: Shape2D

func level_up() -> void:
	for stats_up in level:
		max_hp += max_hp_multiplier * max_hp_base
		attack += attack_multiplier * attack_base
	
	hp = max_hp


func set_level(new_level: int) -> void:
	level = new_level
	level_up()
