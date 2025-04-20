extends Node2D

@onready var dialog_timer = $DialogTimer  # A Timer node with Autostart OFF
@onready var player = get_node("Player")
@onready var black_overlay := $BlackOverlay
var walk_target_x := 0  # 主角要走到的位置
var walk_speed := 100


# Called when the node enters the scene tree for the first time.
func _ready():
	# Step 1: 黑屏淡出
	player.can_throw = false
	black_overlay.modulate.a = 2.0
	var tween = get_tree().create_tween()
	tween.tween_property(black_overlay, "modulate:a", 0.0, 2.0)
	await tween.finished
	print("黑屏结束，可以开始走动")

	# Step 2: 自动走到中央
	player.win_scene = true
	player.can_control = false  # 禁止玩家控制
	await walk_to_position(walk_target_x)

	# Step 3: 等待再播放剧情
	player.animator.play("idle")
	dialog_timer.start(1.6)
	dialog_timer.timeout.connect(_on_dialog_timer_timeout)
	Dialogic.timeline_ended.connect(_on_dialog_ended)
	
func walk_to_position(target_x: float) -> void:
	while player.position.x < target_x:
		player.velocity.x = walk_speed
		player.animator.play("walk")
		player.move_and_slide()
		await get_tree().create_timer(0.01).timeout

	player.velocity = Vector2.ZERO
	
func _on_dialog_timer_timeout():
	player.can_control = false  # Stop movement and actions
	Dialogic.start("final_scene_intro")  # Replace with your Dialogic timeline name

func _on_dialog_ended():
	player.can_control = true  # Restore movement
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
