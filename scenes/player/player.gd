class_name Player
extends Node2D

@export var required_exp: int
@export var experience: int
@export_group('Stats')
@export var max_hp: int
var hp: int 
@export var attack: int = 25
@export var upgrade_increment: int = 25
@export_group('Children Nodes')
@export var body_node: CharacterBody2D
@export var sprite_node: AnimatedSprite2D
@export var ui_node: PlayerUI
@export var game_over_title: Control
@export var monsters_label_node: MonstersLabel
@export var level_prompt_node: LevelPrompt
@export var aura_node: Aura

signal pause(is_paused: bool)
signal game_over
signal retry

func _ready() -> void:
	hp = max_hp
	aura_node.set_player_attack(attack)
	ui_node.player = self
	ui_node.update_ui()


var receive_damage_callable: Callable = Callable(receive_damage)
func receive_damage(damage: int) -> void:
	if hp > 0:
		hp -= damage;
		body_node.player_hurt_animation()
		ui_node.update_ui()
	elif hp <= 0:
		ui_node.update_ui()
		body_node.player_death_animation()


var receive_experience_callable: Callable = Callable(receive_experience)
func receive_experience(exp_points: int) -> void:
	experience += exp_points;
	if experience >= required_exp:
		level_up()
	ui_node.update_ui()


func level_up() -> void:
	if experience > required_exp:
		experience -= required_exp
	else:
		experience = 0
	required_exp += required_exp
	
	level_prompt_node.set_visible(true)
	pause.emit(true)


func _on_level_up_prompt_upgrade(upgrade: int) -> void:
	match upgrade:
		0: attack += upgrade_increment
		1: max_hp += upgrade_increment
	
	hp = max_hp
	
	pause.emit(false)


func _on_character_body_2d_dead() -> void:
	game_over_title.set_visible(true)
	game_over.emit()


func _on_retry_button_pressed() -> void:
	retry.emit()


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
