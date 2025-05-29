extends Node2D

@onready var dialog_timer = $DialogTimer  # A Timer node with Autostart OFF
@onready var player = get_node("Player")
@onready var black_overlay := $BlackOverlay
var walk_target_x := 0  # 主角要走到的位置
var walk_speed := 100
var character_instance: Node = null
@export var lily_scene: PackedScene
var lily_instance: Node2D = null
var end_triggered := true

@export var screen_right_limit := 370
@export var screen_left_limit := -370
# Called when the node enters the scene tree for the first time.
func _ready():
	var lily_dead = Dialogic.VAR.get_variable("kill_lily")
	#$Lily.visible = not lily_dead
	
	if not lily_dead:
		lily_instance = lily_scene.instantiate()
		lily_instance.scale = Vector2(-4, 4)
		lily_instance.can_shoot = false
		add_child(lily_instance)
		lily_instance.position = player.position + Vector2(-80, -19)  # 在主角左边一点
		lily_instance.z_index = player.z_index - 1  # 可选：避免重叠
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
	if lily_instance:
		var lily_anim = lily_instance.get_node("AnimatedSprite2D")
		lily_anim.play("idle")

	# Step 3: 等待再播放剧情
	player.animator.play("idle")
	dialog_timer.start(1.6)
	dialog_timer.timeout.connect(_on_dialog_timer_timeout)
	Dialogic.timeline_ended.connect(_on_dialog_ended)
	end_triggered = false
	
	

	
func walk_to_position(target_x: float) -> void:
	var direction = sign(target_x - player.position.x)

	while abs(player.position.x - target_x) > 2.0:
		player.velocity.x = direction * walk_speed
		player.animator.play("walk")

		# Lily 跟着走（用简单方式模仿主角位置）
		if lily_instance:
			var lily_anim = lily_instance.get_node("AnimatedSprite2D")
			lily_anim.play("walk")
			lily_instance.position.x = player.position.x - 80  # 始终靠左边一点

		player.move_and_slide()
		await get_tree().create_timer(0.01).timeout

	player.velocity = Vector2.ZERO
	player.animator.play("idle")
	
func _on_dialog_timer_timeout():
	player.can_control = false  # Stop movement and actions
	Dialogic.start("final_scene_intro")  # Replace with your Dialogic timeline name

func _on_dialog_ended():
	player.can_control = true  # Restore movement
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not end_triggered and (player.position.x < screen_left_limit or player.position.x > screen_right_limit):
		end_triggered = true
		await fade_out_and_end()
		
		
func fade_out_and_end() -> void:
	player.can_control = false
	var tween = get_tree().create_tween()
	tween.tween_property(black_overlay, "modulate:a", 1.0, 2.0)
	await tween.finished

	$EndCredits.visible = true


	
	await scroll_credits()
	
func scroll_credits():
	var label = $EndCredits/CreditsLabel
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  

	
	label.position.y = $EndCredits.size.y  # 从底部开始
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		label, "position:y",
		-label.size.y-300,  # 滚到顶部
		20.0  # 滚动持续时间
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	get_tree().quit()  # 滚动完后退出或切换场景
