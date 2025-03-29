extends CharacterBody2D

var input
@export var speed = 200
@export var gravity = 10
@export var animator : AnimatedSprite2D
@export var tomato_scene: PackedScene
var facing_right = true
var tomato_timer = 0.0
@export var throw_interval = 0.5  # 每 1.5 秒扔一次

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement(delta)
	tomato_timer += delta
	if tomato_timer > throw_interval:
		tomato_timer = 0
		throw_tomato()
	
func movement(_delta):
	input = Input.get_action_strength("right") - Input.get_action_strength("left") 
	if input != 0:
		if input>0:
			velocity.x = speed
			$AnimatedSprite2D.scale.x = 1
			animator.play("walk")
			facing_right = true
		elif input < 0:
			velocity.x = -speed
			$AnimatedSprite2D.scale.x = -1
			animator.play("walk")
			facing_right = false
	if input == 0:
		velocity.x = 0
		animator.play("idle")
		
	velocity.y += gravity
	move_and_slide()

	
func throw_tomato():
	var tomato = tomato_scene.instantiate()
	tomato.global_position = global_position

	if facing_right:
		tomato.initial_velocity = Vector2(300, -400)
	else:
		tomato.initial_velocity = Vector2(-300, -400)

	get_parent().add_child(tomato)
	
