extends Node2D

@export var enemy_scene : PackedScene
@export var spawn_timer : Timer
@export var spawn_distance := 330 # 离屏外一点生成
@export var spawn_y := 95 # 生成高度，可视情况调整
@export var score : int = 0
@export var score_label : Label
@export var next_level_path: String = ""
@export var player : CharacterBody2D
@export var arrow_hint: AnimatedSprite2D
@export var right_boundary: CollisionShape2D
var spawn_stopped := false
var transition_trigger_x := 335
var transitioned := false
var level_manager: Node




func _ready():

	level_manager = $LevelManager  # 假设你有 LevelManager 节点

func level_complete():
	print("change the scene")
	#await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(next_level_path)
	
func _process(delta: float) -> void:
	if not transitioned and player.position.x >= transition_trigger_x and score >= 5:
		transitioned = true
		get_tree().change_scene_to_file("res://Scenes/Win.tscn")
	score_label.text = "Score: "+ str(score)
	if score >= 5 and not spawn_stopped:
		spawn_timer.stop()
		spawn_stopped = true
		arrow_hint.visible = true
		arrow_hint.modulate.a = 0.5
		right_boundary.disabled = true
		
	
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
		
