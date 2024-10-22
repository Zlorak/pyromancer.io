extends Node2D

@export_group('Child Nodes')
@export var main_menu: Control
@export_group('Timers')
@export var fire_stone_timer: Timer
@export var monster_spawn_timer: Timer
@export var increase_monster_timer: Timer
@export_group('Scenes')
@export var monster_scene: PackedScene
@export var monster_spawn_quantity: int = 1
@export var monster_level: int = 1
@export var fire_stone_scene: PackedScene
@export var map_size_x: int = 0
@export var map_size_y: int = 0
@export var map_margin: int = 50
@export var player_scene: PackedScene
@export var player_spawn: Vector2
var player: Player

signal monster_unsummon

var retry_callable: Callable = Callable(retry)
func retry() -> void:
	monster_unsummon.emit()
	player.queue_free()
	scene_pause(false)
	start_game()


var game_over_pause_callable: Callable = Callable(game_over_pause)
func game_over_pause() -> void:
	player.sprite_node.set_process_mode(3) # Always
	scene_pause(true)


var scene_pause_callable: Callable = Callable(scene_pause)
func scene_pause(is_paused: bool) -> void:
	get_tree().paused = is_paused


func _on_fire_stone_spawn_timer_timeout() -> void:
	var random_position: Vector2
	
	var pos_x: int = randi_range(0, map_size_x)
	var pos_y: int = randi_range(0, map_size_y)
	random_position = Vector2(pos_x, pos_y)
	
	var new_fire_stone: FireStone = fire_stone_scene.instantiate()
	new_fire_stone.set_position(random_position)
	new_fire_stone.set_initial_pos(random_position)
	add_child(new_fire_stone)


func _on_monster_spawn_timer_timeout() -> void:
	for spawn in  monster_spawn_quantity:
		# 0: Top screen spawn
		# 1: Right screen spawn
		# 2: Bottom screen spawn
		# 3: Left screen spawn
		var random_spawn: int = randi_range(0, 3)
		var random_position: Vector2
		var pos_x: int = randi_range(map_margin, map_size_x)
		var pos_y: int = randi_range(map_margin, map_size_y)
		
		match random_spawn:
			0: random_position = Vector2(pos_x, map_margin)
			1: random_position = Vector2(map_margin, pos_y)
			2: random_position = Vector2(pos_x, map_size_y)
			3: random_position = Vector2(map_size_x, pos_y)

		var new_monster: Monster = monster_scene.instantiate()
		new_monster.set_position(random_position)
		new_monster.monster_data.set_level(monster_level)
		new_monster.player = player
		monster_unsummon.connect(new_monster.unsummon_callable)
		add_child(new_monster)


func _on_increase_spawn_timer_timeout() -> void:
	monster_spawn_quantity += 1
	monster_level += 1
	
	player.monsters_label_node.show_label()


func start_game() -> void:
	main_menu.set_visible(false)
	
	monster_spawn_quantity = 1
	monster_level = 1
	
	fire_stone_timer.start()
	monster_spawn_timer.start()
	increase_monster_timer.start()
	
	player = player_scene.instantiate()
	player.pause.connect(scene_pause_callable)
	player.game_over.connect(game_over_pause_callable)
	player.retry.connect(retry_callable)
	player.set_position(player_spawn)
	
	add_child(player)


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()


func _on_start_game_button_pressed() -> void:
	start_game()
