extends Node
@export var enemy_scene: PackedScene = preload("res://Scenes/Enemy.tscn")
@export var level_number: int = 1  # Level selector

@onready var game = get_parent()

var timeline = []
var current_index = 0
var timer: Timer


func _ready():
	match level_number:
		1:
			setup_level_1()
		2:
			setup_level_2()
		3:
			setup_level_3()
		_:
			print("Unknown level, defaulting to Level 1")
			setup_level_1()

	# Set up the spawn timer
	timer = Timer.new()
	timer.one_shot = true  #  ensure it's one-shot
	add_child(timer)
	timer.timeout.connect(_spawn_enemy)

	_start_timeline()


func setup_level_1():
	timeline = [
		{ "start": 0, "end": 15, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small"] },
		{ "start": 15, "end": 30, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		{ "start": 30, "end": 45, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium"] },
		{ "start": 45, "end": 75, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		{ "start": 75, "end": 90, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
		{ "start": 90, "end": 120, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small", "medium", "big"] },
		{ "start": 120, "end": 125, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
	]


func setup_level_2():
	timeline = [
		{ "start": 0, "end": 15, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small"] },  # Trump small
		{ "start": 15, "end": 30, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		{ "start": 30, "end": 45, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium"] },
		{ "start": 45, "end": 75, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		{ "start": 75, "end": 90, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
		{ "start": 90, "end": 120, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small", "medium", "big"] },
		{ "start": 120, "end": 125, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
	]


func setup_level_3():
	timeline = [
		{ "start": 0, "end": 15, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small"] },
		{ "start": 15, "end": 30, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		{ "start": 30, "end": 45, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium"] },
		{ "start": 45, "end": 75, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		{ "start": 75, "end": 90, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
		{ "start": 90, "end": 120, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small", "medium", "big"] },
		{ "start": 120, "end": 125, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
	]


func _start_timeline():
	if current_index >= timeline.size():
		print("Timeline complete!")
		timer.stop()
		return

	var phase = timeline[current_index]
	var duration = phase["end"] - phase["start"]

	print("Starting phase ", current_index, " (", phase, ")")

	# Start spawning
	_schedule_next_spawn(phase)

	# Move to the next phase after 'duration'
	await get_tree().create_timer(duration).timeout
	current_index += 1
	_start_timeline()


func _schedule_next_spawn(phase):
	if phase["type"] in ["continuous", "wave"]:
		var rate_range = phase["spawn_rate"]
		var wait_time = randf_range(rate_range.x, rate_range.y)
		timer.start(wait_time)


func _spawn_enemy():
	if current_index >= timeline.size():
		return

	var phase = timeline[current_index]
	var enemy_type = phase["enemies"].pick_random()

	var enemy = enemy_scene.instantiate()

	var sprite = enemy.get_node_or_null("AnimatedSprite2D")

	match enemy_type:
		"small":
			if level_number == 1 or level_number == 3:
				#enemy.health = 1
				enemy.speed = 50
				if sprite:
					sprite.animation = "walk"
			elif level_number == 2:
				#enemy.health = 3  # Trump as small in Level 2
				enemy.speed = 40
				if sprite:
					sprite.animation = "walk"
		"medium":
			#enemy.health = 3
			enemy.speed = 40
			if sprite:
				sprite.animation = "walk"
			if level_number == 3:
				enemy.revives_left = 5  # Special revive logic in Level 3
		"big":
			#enemy.health = 5
			enemy.speed = 30
			if sprite:
				sprite.animation = "walk"

	game.add_child(enemy)

	var from_left = randf() < 0.5
	var spawn_distance = game.spawn_distance
	var spawn_y = game.spawn_y

	if from_left:
		enemy.global_position = Vector2(-spawn_distance, spawn_y)
		enemy.direction = 1
	else:
		var screen_width = game.get_viewport_rect().size.x
		enemy.global_position = Vector2(screen_width + spawn_distance, spawn_y)
		enemy.direction = -1

	# Schedule next spawn
	_schedule_next_spawn(phase)
