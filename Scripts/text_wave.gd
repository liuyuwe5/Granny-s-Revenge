#extends Area2D
#
#@export var sentence: String = "AI STRATEGY ROAD MAP MATURITY"
#@export var delay_between_chars: float = 0.1
#@export var speed: float = 100.0
#@export var max_distance: float = 400.0
#@export var damage: int = 20
#
#var current_index := 0
#var built_text := ""
#var move_dir := Vector2.LEFT
#var start_position := Vector2.ZERO
#
#func _ready():
	#start_position = global_position
	##body_entered.connect(_on_body_entered)
	#start_typing()
#
#func set_direction(dir: Vector2):
	#move_dir = dir.normalized()
#
#func _process(delta):
	#position += move_dir * speed * delta
	#if global_position.distance_to(start_position) > max_distance:
		#queue_free()
#
#func start_typing():
	#add_char()
#
#func add_char():
	#if current_index >= sentence.length():
		#return
#
	#built_text += sentence[current_index]
	#current_index += 1
	#$Label.text = built_text
#
	#update_collision_size()
#
	#var timer = Timer.new()
	#timer.one_shot = true
	#timer.wait_time = delay_between_chars
	#add_child(timer)
	#timer.timeout.connect(func ():
		#add_char()
		#timer.queue_free()
	#)
	#timer.start()
#
#func update_collision_size():
	#await get_tree().process_frame
	#var size = $Label.get_size()
	#if $CollisionShape2D.shape is RectangleShape2D:
		#var shape = $CollisionShape2D.shape as RectangleShape2D
		#shape.size = size + Vector2(8, 4)  # 给一点 padding
#extends Area2D
#
#@export var sentence: String = "AI STRATEGY ROAD MAP MATURITY"
#@export var delay_between_chars: float = 0.1
#@export var speed: float = 100.0
#@export var max_distance: float = 400.0
#@export var damage: int = 20
#
#var current_index := 0
#var built_text := ""
#var move_dir := Vector2.LEFT
#var start_position := Vector2.ZERO
#
#func _ready():
	#start_position = global_position
	##body_entered.connect(_on_body_entered)
	#start_typing()
#
#func set_direction(dir: Vector2):
	#move_dir = dir.normalized()
#
#func _process(delta):
	#position += move_dir * speed * delta
	#if global_position.distance_to(start_position) > max_distance:
		#queue_free()
#
#func start_typing():
	#add_char()
#
#func add_char():
	#if current_index >= sentence.length():
		#queue_later()
		#return
#
	#built_text += sentence[current_index]
	#current_index += 1
	#$Label.text = built_text
#
	#update_collision_size()
#
	#var timer = Timer.new()
	#timer.one_shot = true
	#timer.wait_time = delay_between_chars
	#add_child(timer)
	#timer.timeout.connect(func ():
		#add_char()
		#timer.queue_free()
	#)
	#timer.start()
#
#func queue_later():
	#var delay = Timer.new()
	#delay.one_shot = true
	#delay.wait_time = 1.0  # 播完整句后停一秒
	#add_child(delay)
	#delay.timeout.connect(func ():
		#queue_free()
		#delay.queue_free()
	#)
	#delay.start()
#
#func update_collision_size():
	#await get_tree().process_frame
	#var size = $Label.get_size()
	#if $CollisionShape2D.shape is RectangleShape2D:
		#var shape = $CollisionShape2D.shape as RectangleShape2D
		#shape.size = size + Vector2(8, 4)  # 给一点 padding
extends Area2D

@export var gravity_text: float = 100
@export var initial_velocity: Vector2 = Vector2(150, -300)
@export var damage: int = 10
@export var lifetime: float = 10

var velocity := Vector2.ZERO
var start_position: Vector2
var _pending_text: String = ""
var _ready_to_initialize := false

func set_text(word: String):
	_pending_text = word

func _ready():
	start_position = global_position
	velocity = initial_velocity
	body_entered.connect(_on_body_entered)

	$Label.text = _pending_text

	# 等待一帧再设置 label 大小
	_initialize_later()

	# 自动销毁定时器
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = lifetime
	add_child(timer)
	timer.timeout.connect(queue_free)
	timer.start()

func _initialize_later():
	# 安全地等待一帧再获取 label 尺寸
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = 5  # 等 1 帧
	add_child(t)
	t.timeout.connect(func ():
		_update_collision_size()
		t.queue_free()
	)
	t.start()

func _update_collision_size():
	#var label_size = $Label.get_size()
	#if $CollisionShape2D.shape is RectangleShape2D:
		#var shape = $CollisionShape2D.shape as RectangleShape2D
		#shape.size = label_size  # + Vector2(6, 4)
	var label_size = $Label.get_size()
	if $CollisionShape2D.shape is RectangleShape2D:
		var shape = $CollisionShape2D.shape as RectangleShape2D
		# 缩小碰撞框为文字的一部分，例如宽高 40%
		shape.size = label_size * Vector2(0.4, 0.4)
		


func _process(delta):
	velocity.y += gravity_text * delta
	position += velocity * delta

func _on_body_entered(body: Node):
	if body.name == "Player" or body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
