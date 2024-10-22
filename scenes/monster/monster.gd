class_name Monster
extends AnimatedSprite2D

# Meant to be edited later. This sets up a future feature
# so multiple monsters can be added. Monster is the base class.
# TO-DO:
# - Add pain_audio_resource and attack_audio_resource to MonsterResource
# - Load those into the AudioStreamPlayer2D nodes at _ready()
#@export var monsters: Array[MonsterResource]
@export var monster_data: MonsterResource
@export var pain_audio: AudioStreamPlayer2D
@export var attack_audio: AudioStreamPlayer2D
var player: Player

signal transmit_damage(damage: int)
signal transmit_exp(exp_points: int)

var chasing_state: ChasingState = ChasingState.PASSIVE
enum ChasingState {
	# Refreshes chase_position every frame
	ACTIVE, 
	# Refreshes chase_position only if encounters player_aggro area or
	# it arrived to chase_position already
	PASSIVE,
}
var combat_state: CombatState
enum CombatState {
	CHASING,
	ATTACKING,
	HURT,
	DEAD
}
var chase_position: Vector2
var enemy_in_range: bool = false
var hurt_cd: bool = false

func _ready() -> void:
	transmit_damage.connect(player.receive_damage_callable)
	transmit_exp.connect(player.receive_experience_callable)
	chase_position = player.body_node.get_global_position()


func _process(delta: float) -> void:
	match chasing_state:
		ChasingState.PASSIVE:
			if global_position == chase_position:
				chase_position = player.body_node.get_global_position()
				move(delta)
			else:
				move(delta)
		ChasingState.ACTIVE:
			if !enemy_in_range and combat_state == CombatState.CHASING:
				chase_position = player.body_node.get_global_position()
				move(delta)


func move(delta: float) -> void:
	play('walk')
	var direction = chase_position - global_position
	var velocity = direction * monster_data.speed
	velocity = velocity.normalized() * monster_data.speed
	global_position += velocity * delta

	if velocity.x > 0:
		flip_h = true
	else:
		flip_h = false


func attack() -> void:
	play('attack')
	attack_audio.play()


func die() -> void:
	combat_state = CombatState.DEAD
	play("death")


func hurt() -> void:
	combat_state = CombatState.HURT
	play("hurt")
	pain_audio.play()
	hurt_cd = true


func _on_frame_changed() -> void:
	if combat_state == CombatState.ATTACKING:
		if get_frame() == monster_data.attack_frame and enemy_in_range:
			transmit_damage.emit(monster_data.attack)
	if combat_state == CombatState.HURT:
		if get_frame() == monster_data.hurt_frame:
			# This should be monster_data.hp in case monsters can heal,
			# but I dont have time to implement this right now
			monster_data.max_hp -= player.attack 
			if monster_data.max_hp <= 0:
				die()


func _on_body_area_area_entered(area: Area2D) -> void:
	if area.is_in_group('player_aggro'):
		chasing_state = ChasingState.ACTIVE
	if area.is_in_group('fireball'):
		if !hurt_cd:
			hurt()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		enemy_in_range = true
		combat_state = CombatState.ATTACKING
		attack()


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		enemy_in_range = false


func _on_animation_finished() -> void:
	if combat_state == CombatState.DEAD:
		transmit_exp.emit(monster_data.experience)
		queue_free()
	if combat_state == CombatState.ATTACKING:
		if enemy_in_range:
			attack()
		else:
			hurt_cd = false
			combat_state = CombatState.CHASING
	if combat_state == CombatState.HURT:
		hurt_cd = false
		if enemy_in_range:
			attack()
		else:
			combat_state = CombatState.CHASING


var unsummon_callable: Callable = Callable(unsummon)
func unsummon() -> void:
	queue_free()
