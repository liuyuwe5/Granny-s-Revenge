extends Node
@export var enemy_scene: PackedScene = preload("res://Scenes/Enemy.tscn")
@export var level_number: int = 1  # Level selector

@onready var game = get_parent()
var active_enemies: Array = []

var timeline = []
var current_index = 0
var timer: Timer

var timeline_total_time := 0.0
var timeline_elapsed_time := 0.0
var progress_bar_max := 95.0  # 初始最多推进到 95%

var kills_since_last_special := 0
@export var kills_needed_for_special := 5  # 冷却门槛
@export var special_hint_sound: AudioStreamPlayer2D

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
			

	## Set up the spawn timer
	#timer = Timer.new()
	#timer.one_shot = true  #  ensure it's one-shot
	#add_child(timer)
	#timer.timeout.connect(_spawn_enemy)
#
	#_start_timeline()
	# 计算总 timeline 时长
	timeline_total_time = 0.0
	for phase in timeline:
		timeline_total_time += phase["end"] - phase["start"]

	# Set up the spawn timer
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_spawn_enemy)

	# 启动 timeline 和进度条更新
	_start_timeline()
	_start_progress_bar()

func setup_level_1():
	timeline = [
	{ "start": 0, "end": 5, "type": "continuous", "spawn_rate": Vector2(2, 4), "enemies": ["small"] },
	{ "start": 10, "end": 20, "type": "wave", "spawn_rate": Vector2(1, 2), "enemies": ["small"] },
	{ "start": 20, "end": 30, "type": "continuous", "spawn_rate": Vector2(2, 4), "enemies": ["small", "medium"] },
	{ "start": 30, "end": 40, "type": "wave", "spawn_rate": Vector2(1, 2), "enemies": ["small", "medium"] },
	{ "start": 40, "end": 50, "type": "continuous", "spawn_rate": Vector2(2, 3), "enemies": ["medium"] }
]



func setup_level_2():
	timeline = [
		{ "start": 0, "end": 5, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small"] },
#
		{ "start": 15, "end": 30, "type": "continuous", "spawn_rate": Vector2(0, 2), "enemies": ["small", "medium"] },
		{ "start": 30, "end": 45, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["medium"] },
		{ "start": 45, "end": 60, "type": "continuous", "spawn_rate": Vector2(0, 2), "enemies": ["small", "medium", "big"] },
		{ "start": 60, "end": 70, "type": "continuous", "spawn_rate": Vector2(0, 2), "enemies": ["small", "medium", "big"] },
		#
		#{ "start": 0, "end": 15, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small"] },
		#{ "start": 15, "end": 30, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		#{ "start": 30, "end": 45, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium"] },
		#{ "start": 45, "end": 75, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small"] },
		#{ "start": 75, "end": 90, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
		#{ "start": 90, "end": 120, "type": "wave", "spawn_rate": Vector2(0, 2), "enemies": ["small", "medium", "big"] },
		#{ "start": 120, "end": 125, "type": "continuous", "spawn_rate": Vector2(1, 5), "enemies": ["small", "medium", "big"] },
	]


func setup_level_3():
	timeline = [
		{ "start": 0, "end": 5, "type": "continuous", "spawn_rate": Vector2(0.8, 3), "enemies": ["big"] },
		{ "start": 10, "end": 25, "type": "wave", "spawn_rate": Vector2(0.3, 1.5), "enemies": ["small", "medium"] },
		{ "start": 25, "end": 40, "type": "continuous", "spawn_rate": Vector2(0.6, 2.5), "enemies": ["small", "medium"] },
		{ "start": 40, "end": 60, "type": "wave", "spawn_rate": Vector2(0.2, 1.2), "enemies": ["medium"] },
		{ "start": 60, "end": 85, "type": "continuous", "spawn_rate": Vector2(0.8, 2.5), "enemies": ["small", "medium", "big"] },
		{ "start": 85, "end": 110, "type": "wave", "spawn_rate": Vector2(0.1, 1), "enemies": ["medium", "big"] },
		{ "start": 110, "end": 125, "type": "continuous", "spawn_rate": Vector2(0.5, 2), "enemies": ["small", "medium", "big"] },
	]


#func _start_timeline():
	#print(current_index)
	#if current_index >= timeline.size():
		#print("Timeline complete!")
		#timer.stop()
		#return
#
	#var phase = timeline[current_index]
	#var duration = phase["end"] - phase["start"]
#
	#print("Starting phase ", current_index, " (", phase, ")")
#
	## Start spawning
	#_schedule_next_spawn(phase)
#
	## Move to the next phase after 'duration'
	#await get_tree().create_timer(duration).timeout
	#current_index += 1
	#_start_timeline()
func _start_timeline():
	if current_index >= timeline.size():
		print("Timeline complete!")
		timer.stop()
		if active_enemies.is_empty():
			print("✅ No enemies ever spawned. Ending level directly.")
			
			var bar = get_tree().current_scene.get_node("CanvasLayer/ProgressBar")
			if bar:
				bar.value = 100.0  # 推到 100%

			await get_tree().create_timer(2.0).timeout
			get_tree().current_scene.level_complete()
			
		return

	var phase = timeline[current_index]
	var duration = phase["end"] - phase["start"]
	print("Starting phase ", current_index, " (", phase, ")")

	# Start spawning
	_schedule_next_spawn(phase)

	# Wait for this phase to finish
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

	var base_health := 1
	var base_speed := 50

	# 控制左右生成
	var allow_right_side = false
	match level_number:
		1:
			allow_right_side = false
		2:
			allow_right_side = current_index >= 4
		3:
			allow_right_side = true
		_:
			allow_right_side = false
	# 设置敌人属性
	match enemy_type:
		"small":
			#if level_number == 2:
				#base_health = 3
				#base_speed = 40
			#else:
			base_health = 1
			base_speed = 50
		"medium":
			#if level_number == 3:
				#base_health = 5
			#else:
			base_health = 2
			base_speed = 40
		"big":
			#if level_number == 3:
				#base_health = 7
			#else:
			base_health = 3
			base_speed = 30
			
	var from_left = choose_spawn_side(0.6, allow_right_side)
			
	var direction = 1
	if not from_left:
		direction = -1
	var enemy = enemy_scene.instantiate()
	enemy.configure(base_speed, base_health, direction, enemy_type)  # ✅ 添加 enemy_type
	
	# 添加信号监听
	enemy.connect("tree_exited", Callable(self, "_on_enemy_died"))
	active_enemies.append(enemy)

	# 设置位置
	var spawn_distance = game.spawn_distance
	var spawn_y = game.spawn_y
	if enemy_type == "big":
		spawn_y = game.spawn_y - 5
		spawn_distance = spawn_distance + 100
		
	var screen_width = game.get_viewport_rect().size.x

	var spawn_position: Vector2
	if from_left:
		print("spawn left")
		spawn_position = Vector2(-spawn_distance, spawn_y)
	else:
		spawn_position = Vector2(spawn_distance, spawn_y)
		print("spawn right")

	enemy.global_position = spawn_position
	game.add_child(enemy)
	_schedule_next_spawn(phase)


func _start_progress_bar():
	var bar = get_tree().current_scene.get_node("CanvasLayer/ProgressBar")
	if not bar:
		print("⚠️ Progress bar not found")
		return

	while timeline_elapsed_time < timeline_total_time:
		await get_tree().process_frame
		timeline_elapsed_time += get_process_delta_time()

		var ratio = timeline_elapsed_time / timeline_total_time
		bar.value = clamp(ratio * progress_bar_max, 0, progress_bar_max)
		
func _process(delta):
	if kills_since_last_special >= kills_needed_for_special:
		get_tree().current_scene.can_use_special = true
	if Input.is_action_just_pressed("special_attack") and kills_since_last_special >= kills_needed_for_special:
		var player = game.get_node("Player")
		if player:
			trigger_special_attack(player.global_position)
			kills_since_last_special = 0  
			get_tree().current_scene.can_use_special = false

		
func _on_enemy_died():
	if not is_inside_tree():
		return
		
	# 有敌人 queue_free() 后就会触发这个
	await get_tree().process_frame
	active_enemies = active_enemies.filter(func(e): return e != null and e.is_inside_tree())
	
	kills_since_last_special += 1  
	
	if current_index >= timeline.size() and active_enemies.is_empty():
		print("✅ All enemies defeated, moving to next level!")
		
		
		var bar = get_tree().current_scene.get_node("CanvasLayer/ProgressBar")
		if bar:
			bar.value = 100.0  # 推到 100%

		await get_tree().create_timer(2.0).timeout
		get_tree().current_scene.level_complete()
		
#func trigger_special_attack(center_position: Vector2):
	#var enemies_with_distance := []
#
	#for enemy in active_enemies:
		#if enemy and enemy.is_inside_tree():
			#var dist = center_position.distance_to(enemy.global_position)
			#enemies_with_distance.append({ "enemy": enemy, "distance": dist })
#
	## 按距离排序
	#enemies_with_distance.sort_custom(func(a, b): return a["distance"] < b["distance"])
#
	## 对最近的五个敌人 -1 HP
	#for i in range(min(5, enemies_with_distance.size())):
		#var target = enemies_with_distance[i]["enemy"]
		#if target.has_method("take_damage"):
			#target.take_damage(1)
			
func trigger_special_attack(center_position: Vector2):
	special_hint_sound.play()
	var enemies_with_distance := []

	for enemy in active_enemies:
		if enemy and enemy.is_inside_tree():
			var dist = center_position.distance_to(enemy.global_position)
			enemies_with_distance.append({ "enemy": enemy, "distance": dist })

	# 排序
	enemies_with_distance.sort_custom(func(a, b): return a["distance"] < b["distance"])

	# 发射五个番茄
	var tomato_scene = preload("res://Scenes/TomatoBuff.tscn")
	for i in range(min(5, enemies_with_distance.size())):
		var target = enemies_with_distance[i]["enemy"]
		assert(target is Node2D)
		var tomato = tomato_scene.instantiate()
		tomato.global_position = center_position
		tomato.target = target
		add_child(tomato)
