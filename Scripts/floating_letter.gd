#extends Area2D
#
#
#@export var speed: float = 100.0
#@export var max_distance: float = 300.0
#
#var move_dir: Vector2 = Vector2.ZERO
#var start_position: Vector2
#
#func _ready():
	#start_position = global_position
	#body_entered.connect(_on_body_entered)
#
#func set_text(t: String):
	#print("text: " + t)
	#$Label.text = t
	#await get_tree().process_frame  # 等待一帧让 Label 尺寸更新
	#var label_size = $Label.get_size()
	#var shape = $CollisionShape2D.shape as RectangleShape2D
	#shape.size = label_size + Vector2(4, 4)  # 给一点 padding 避免太小或太紧
#
#func set_direction(dir: Vector2):
	#move_dir = dir.normalized()
#
#func _process(delta):
	#position += move_dir * speed * delta
	#if global_position.distance_to(start_position) > max_distance:
		#queue_free()
#
#func _on_body_entered(body: Node):
	#if body.name == "Player":
		#if body.has_method("take_damage"):
			#body.take_damage(10)
		#queue_free()
extends Area2D

@export var speed: float = 100.0
@export var max_distance: float = 300.0

var move_dir: Vector2 = Vector2.ZERO
var start_position: Vector2
var _pending_text: String = ""

func set_text(t: String):
	_pending_text = t  # 暂存文字内容，避免 get_tree() 报错

func set_direction(dir: Vector2):
	move_dir = dir.normalized()

func _ready():
	start_position = global_position

	# 应用文字
	$Label.text = _pending_text

	# 等一帧，让 Label 渲染出大小
	await get_tree().process_frame

	# 自动设置碰撞框大小
	var label_size = $Label.get_size()
	if $CollisionShape2D.shape is RectangleShape2D:
		var shape = $CollisionShape2D.shape as RectangleShape2D
		shape.size = label_size + Vector2(4, 4)  # 添加一点 padding

	# 连接碰撞信号
	body_entered.connect(_on_body_entered)

func _process(delta):
	position += move_dir * speed * delta

	if global_position.distance_to(start_position) > max_distance:
		queue_free()

func _on_body_entered(body: Node):
	if body.name == "Player" or body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(10)
		queue_free()
