extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

@export var time: int = 0
@export var max_enemies: int = 115       # << LIMITE DE INIMIGOS
@export var cull_distance: float = 6000.0

signal changetime(time)

func _ready():
	connect("changetime", Callable(player, "change_time"))

func _on_timer_timeout():
	time += 1

	cull_distant_enemies()

	# Conta quantos inimigos existem atualmente
	var current_enemies := get_enemy_count()

	# Para cada tipo
	for spawn_data in spawns:

		# Ativo após o tempo definido
		if time >= spawn_data.time_start:

			# Delay normal
			if spawn_data.spawn_delay_counter < spawn_data.enemy_spawn_delay:
				spawn_data.spawn_delay_counter += 1
				continue
			
			spawn_data.spawn_delay_counter = 0

			# Spawna, mas respeitando o limite total
			var amount_to_spawn := spawn_data.enemy_num

			for n in amount_to_spawn:
				if current_enemies >= max_enemies:
					break

				var enemy = spawn_data.enemy.instantiate()
				var pos = get_random_position()

				if is_position_valid(pos):
					enemy.global_position = pos
					add_child(enemy)
					current_enemies += 1

	emit_signal("changetime", time)


func get_enemy_count() -> int:
	var count := 0
	for c in get_children():
		if c is CharacterBody2D:
			count += 1
	return count


func cull_distant_enemies():
	for child in get_children():
		if child is CharacterBody2D:
			var dist = child.global_position.distance_to(player.global_position)
			if dist > cull_distance:
				child.queue_free()


func is_position_valid(pos: Vector2) -> bool:
	if player.map_bounds.left != 0 and player.map_bounds.right != 0:
		return pos.x >= player.map_bounds.left and pos.x <= player.map_bounds.right and \
			   pos.y >= player.map_bounds.top and pos.y <= player.map_bounds.bottom
	return true


func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.2, 1.5)

	var left = player.global_position.x - vpr.x/2
	var right = player.global_position.x + vpr.x/2
	var top = player.global_position.y - vpr.y/2
	var bottom = player.global_position.y + vpr.y/2

	var side = ["up","down","right","left"].pick_random()

	match side:
		"up":
			return Vector2(randf_range(left, right), top)
		"down":
			return Vector2(randf_range(left, right), bottom)
		"left":
			return Vector2(left, randf_range(top, bottom))
		"right":
			return Vector2(right, randf_range(top, bottom))

	return player.global_position
