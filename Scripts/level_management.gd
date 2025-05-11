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
	{ "start": 0, "end": 10, "type": "continuous", "spawn_rate": Vector2(2, 4), "enemies": ["small"] },
	{ "start": 10, "end": 20, "type": "wave", "spawn_rate": Vector2(1, 2), "enemies": ["small"] },
	{ "start": 20, "end": 30, "type": "continuous", "spawn_rate": Vector2(2, 4), "enemies": ["small", "medium"] },
	{ "start": 30, "end": 40, "type": "wave", "spawn_rate": Vector2(1, 2), "enemies": ["small", "medium"] },
	{ "start": 40, "end": 50, "type": "continuous", "spawn_rate": Vector2(2, 3), "enemies": ["medium"] }
]



func setup_level_2():
	timeline = [
		{ "start": 0, "end": 15, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small"] },
		{ "start": 15, "end": 30, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		{ "start": 30, "end": 45, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium"] },
		{ "start": 45, "end": 75, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		{ "start": 75, "end": 90, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
		{ "start": 90, "end": 120, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small", "medium", "big"] },
		{ "start": 120, "end": 125, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
	]


func setup_level_3():
	timeline = [
		{ "start": 0, "end": 10, "type": "continuous", "spawn_rate": Vector2(0.8, 3), "enemies": ["small"] },
		{ "start": 10, "end": 25, "type": "wave", "spawn_rate": Vector2(0.3, 1.5), "enemies": ["small", "medium"] },
		{ "start": 25, "end": 40, "type": "continuous", "spawn_rate": Vector2(0.6, 2.5), "enemies": ["small", "medium"] },
		{ "start": 40, "end": 60, "type": "wave", "spawn_rate": Vector2(0.2, 1.2), "enemies": ["medium"] },
		{ "start": 60, "end": 85, "type": "continuous", "spawn_rate": Vector2(0.8, 2.5), "enemies": ["small", "medium", "big"] },
		{ "start": 85, "end": 110, "type": "wave", "spawn_rate": Vector2(0.1, 1), "enemies": ["medium", "big"] },
		{ "start": 110, "end": 125, "type": "continuous", "spawn_rate": Vector2(0.5, 2), "enemies": ["small", "medium", "big"] },
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


var last_spawned_side = "right"  # Used to alternate spawn sides

func choose_spawn_side(bias: float = 0.8, allow_right_side := false) -> bool:
	if not allow_right_side:
		return true  # Force spawn from left side only
	if last_spawned_side == "left":
		last_spawned_side = "right"
		return false
	else:
		last_spawned_side = "left"
		return true

func _spawn_enemy():
	if current_index >= timeline.size():
		return

	var phase = timeline[current_index]
	var enemy_type = phase["enemies"].pick_random()

	var enemy = enemy_scene.instantiate()
	var sprite = enemy.get_node_or_null("AnimatedSprite2D")

	# Default values
	var base_health := 1
	var base_speed := 50
	var from_left = true
	var allow_right_side = false

	# -------- CONTROL RIGHT-SIDE SPAWNS BASED ON LEVEL & TIMELINE PHASE --------
	if level_number == 1:
		allow_right_side = false  # All from left in level 1
	elif level_number == 2:
		allow_right_side = current_index >= 4  # Introduce right side later
	elif level_number == 3:
		allow_right_side = true  # Full two-sided spawn in level 3

	# -------- ENEMY TYPE STATS --------
	match enemy_type:
		"small":
			base_health = 1
			base_speed = 50
			if level_number == 2:
				base_health = 3 
				base_speed = 40
			if sprite:
				sprite.animation = "walk"
		"medium":
			base_health = 3
			base_speed = 40
			if level_number == 3:
				base_health = 5
			if sprite:
				sprite.animation = "walk"
		"big":
			base_health = 5
			base_speed = 30
			if level_number == 3:
				base_health = 7
			if sprite:
				sprite.animation = "walk"

	# -------- APPLY STATS AND POSITION --------
	enemy.speed = base_speed
	if "health" in enemy:
		enemy.health = base_health

	game.add_child(enemy)

	from_left = choose_spawn_side(0.8, allow_right_side)

	var spawn_distance = game.spawn_distance
	var spawn_y = game.spawn_y

	if from_left:
		enemy.global_position = Vector2(-spawn_distance, spawn_y)
		enemy.direction = 1
	else:
		var screen_width = game.get_viewport_rect().size.x
		enemy.global_position = Vector2(screen_width + spawn_distance, spawn_y)
		enemy.direction = -1

	_schedule_next_spawn(phase)
