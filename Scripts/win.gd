extends Node2D

@onready var dialog_timer = $DialogTimer  # A Timer node with Autostart OFF
@onready var player = get_node("Player")
@onready var black_overlay := $BlackOverlay
var walk_target_x := 0  # 主角要走到的位置
var walk_speed := 100
#@onready var character_placeholder := $CharacterPlaceholder  # 你要加角色的位置（比如一个 Node2D 占位符）
#@export var character_scene: PackedScene  # 在 Inspector 中拖进角色场景
var character_instance: Node = null
@export var lily_scene: PackedScene
var lily_instance: Node2D = null

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
	
#func walk_to_position(target_x: float) -> void:
	#while player.position.x < target_x:
		#player.velocity.x = walk_speed
		#player.animator.play("walk")
		#player.move_and_slide()
		#await get_tree().create_timer(0.01).timeout
#
	#player.velocity = Vector2.ZERO
	
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
	pass
