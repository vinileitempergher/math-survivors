extends Node2D


@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

@export var time: int = 0
@export var max_enemies: int = 150
@export var cull_distance: float = 800.0

var enemy_count: int = 0

signal changetime(time)

func _ready():
	connect("changetime",Callable(player,"change_time"))

func _on_timer_timeout():
	time += 1
	cull_distant_enemies()
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num and enemy_count < max_enemies:
					var enemy_spawn = new_enemy.instantiate()
					var spawn_pos = get_random_position()
					if is_position_valid(spawn_pos):
						enemy_spawn.global_position = spawn_pos
						enemy_spawn.connect("remove_from_array", Callable(self, "_on_enemy_removed"))
						add_child(enemy_spawn)
						enemy_count += 1
					counter += 1
	emit_signal("changetime",time)

func _on_enemy_removed(_enemy):
	enemy_count = max(0, enemy_count - 1)

func cull_distant_enemies():
	for child in get_children():
		if child is CharacterBody2D:
			var distance = child.global_position.distance_to(player.global_position)
			if distance > cull_distance:
				child.queue_free()
				enemy_count = max(0, enemy_count - 1)

func is_position_valid(pos: Vector2) -> bool:
	if player.map_bounds.left != 0 and player.map_bounds.right != 0:
		return pos.x >= player.map_bounds.left and pos.x <= player.map_bounds.right and \
			   pos.y >= player.map_bounds.top and pos.y <= player.map_bounds.bottom
	return true

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y,spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
