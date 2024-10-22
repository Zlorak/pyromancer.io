class_name PlayerMovement
extends CharacterBody2D

@export var speed: int = 200
@export var animated_node: AnimatedSprite2D

signal add_projectile
signal dead

enum AnimationState {
	WALKING,
	IDLE,
	HURT,
	DEATH
}
var animationState: AnimationState = AnimationState.WALKING

func move(delta: float):
	if animationState != AnimationState.HURT:
		animationState = AnimationState.WALKING
		animated_node.play("walk")
		
	# Move the player
	velocity = velocity.normalized() * speed
	move_and_slide()
	
	# Flip the sprite left/right
	if velocity.x > 0: 
		animated_node.flip_h = false
	elif velocity.x < 0:
		animated_node.flip_h = true

	# Reset velocity
	velocity = Vector2.ZERO


func animationCheck():
	match animationState:
		AnimationState.DEATH:
			animated_node.play("death")
		AnimationState.HURT:
			animated_node.play('hurt')
		AnimationState.WALKING:
			animated_node.play("walk")
		AnimationState.IDLE:
			animated_node.play("idle")


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	
	animationCheck()

	if animationState != AnimationState.DEATH:
		if velocity.length() > 0:
			move(delta)
		elif animationState != AnimationState.HURT:
			animationState = AnimationState.IDLE


func player_hurt_animation():
	animationState = AnimationState.HURT


func player_death_animation():
	animationState = AnimationState.DEATH


func _on_animated_sprite_2d_animation_finished() -> void:
	if animationState == AnimationState.HURT:
		if velocity.length() > 0:
			animationState = AnimationState.WALKING
		if velocity.length() == 0:
			animationState = AnimationState.IDLE
	if animationState == AnimationState.DEATH:
		dead.emit()
