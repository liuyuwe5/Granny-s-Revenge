extends Node2D


@export var enemy_scene : PackedScene
@export var spawn_timer : Timer
@export var spawn_distance := 330 # 离屏外一点生成
@export var spawn_y := 80 # 生成高度，可视情况调整
@export var score : int = 0
@export var score_label : Label

func _ready():
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	
	
func _process(delta: float) -> void:
	score_label.text = "Score: "+ str(score)
	
func _on_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)

	var from_left = randf() < 0.5

	if from_left:
		enemy.global_position = Vector2(-spawn_distance, spawn_y)
		enemy.direction = 1
	else:
		var screen_width = get_viewport_rect().size.x
		enemy.global_position = Vector2(screen_width + spawn_distance, spawn_y)
		enemy.direction = -1
#func show_game_over():
	#game_over_label.visible = true
