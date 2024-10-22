class_name Aura
extends Node2D

@export var frequency: float = 2
@export var aura_radius: float = 50
@export var aura_increment: int = 0
@export var projectile_scale_increment: Vector2 = Vector2(0.1, 0.1)
var projectile_scale: Vector2 = Vector2(0, 0)
@export var max_projectile_scale: Vector2 = Vector2(0.5, 0.5)
@export var projectile_amount: int = 1
var player_attack: int
var projectile_nodes: Array[Fireball]
@export_group('PackedScenes')
@export var fireball_scene: PackedScene

var rotate_radian: float = PI

func _ready() -> void:
	circle_position()


func _process(delta: float) -> void:
	rotate_radian -= delta * frequency
	set_rotation(rotate_radian)
	
	if rotate_radian <= -PI:
		rotate_radian = PI


func circle_position() -> void:
	var circle_angle: float = PI * 2
	var projectile_position: Vector2
	
	circle_angle = circle_angle/projectile_amount
	var projectile_angle: float = circle_angle
	for projectile in projectile_amount:
		var x: float = aura_radius * sin(projectile_angle)
		var y: float = aura_radius * -cos(projectile_angle)
		projectile_position = Vector2(x, y)
		
		var new_projectile: Fireball = fireball_scene.instantiate()
		new_projectile.set_position(projectile_position)
		new_projectile.set_rotation(projectile_angle)
		new_projectile.set_damage(player_attack)
		new_projectile.scale += projectile_scale
		projectile_nodes.append(new_projectile)
		add_child(new_projectile)
		
		projectile_angle += circle_angle


func set_player_attack(attack: int) -> void:
	player_attack = attack


func _on_character_body_2d_add_projectile() -> void:
	for projectile in projectile_nodes:
		projectile.queue_free()
	projectile_nodes.clear()
	
	aura_radius += aura_increment
	projectile_amount += 1
	if projectile_scale.x <= max_projectile_scale.x:
		projectile_scale += projectile_scale_increment
	call_deferred('circle_position')
