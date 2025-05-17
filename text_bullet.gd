extends Area2D

@export var gravity_text: float = 100
@export var initial_velocity: Vector2 = Vector2(150, -100)
@export var damage: int = 1
@export var lifetime: float = 5.0
@export var sentence: String = "YOU ARE REPLACEABLE"

var velocity := Vector2.ZERO
var start_position: Vector2

func set_text(text: String):
	sentence = text
	if $Label:
		$Label.text = sentence

func set_direction(dir: Vector2):
	initial_velocity = dir.normalized() * initial_velocity.length()

func _ready():
	if $CollisionShape2D.shape is RectangleShape2D:
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	start_position = global_position
	velocity = initial_velocity
	$Label.text = sentence
	_update_collision_size()
	
	monitoring = true
	body_entered.connect(_on_body_entered)
	
	# 自动销毁
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = lifetime
	add_child(timer)
	timer.timeout.connect(queue_free)
	timer.start()

func _process(delta):
	velocity.y += gravity_text * delta
	position += velocity * delta

func _update_collision_size():
	await get_tree().process_frame
	var label_size = $Label.get_size()
	if $CollisionShape2D.shape is RectangleShape2D:
		var shape = $CollisionShape2D.shape as RectangleShape2D
		shape.size = label_size * Vector2(0.9, 0.8)
		$CollisionShape2D.position = $Label.position + label_size * 0.5

func _on_body_entered(body: Node):
	if body.has_method("take_damage"):
		$Label.add_theme_color_override("font_color", Color.RED)
		$Label.add_theme_color_override("font_outline_color", Color.DARK_RED)
		body.take_damage()
		await get_tree().create_timer(0.2).timeout
		queue_free()
