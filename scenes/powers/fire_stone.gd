class_name FireStone
extends Sprite2D

@export var shadow_sprite: Sprite2D
## Number of times the sine wave completes a cycle in one second.
@export var frequency: float = 2
## Maximum height of the sine wave.
@export var amplitude: float = 0.1
## Time indicates our position in the sine wave.
var time: float = PI
var initial_pos: Vector2
var new_pos: Vector2 = Vector2.ZERO
var shadow_position: Vector2
var shadow_scaling: Vector2 = get_scale()

func _ready() -> void:
	$Sprite2D.set_position(get_position())


func _process(delta) -> void:
	time -= delta
	initial_pos += sine_effect(time)
	set_position(initial_pos)
	#shadow_scale(time)
	
	if time <= 0:
		time = PI


func set_initial_pos(new_position: Vector2) -> void:
	initial_pos = new_position
	

func sine_effect(time: float) -> Vector2:
	# Axis Y will be the one fluctuating here.
	new_pos.y = sin(time * frequency) * amplitude 
	
	return new_pos

# I'll do this later...
#func shadow_scale(time: float) -> void:
	#shadow_scaling.x = cos(time * (frequency / 2)) * amplitude
	#shadow_scaling.y = cos(time * (frequency / 2)) * amplitude
	#if shadow_scaling.x < PI/2:
		#shadow_sprite.scale = shadow_scaling
	#else:
		#shadow_sprite.scale = Vector2.ZERO


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.add_projectile.emit()
		queue_free()
