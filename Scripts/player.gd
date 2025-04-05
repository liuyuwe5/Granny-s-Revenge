extends CharacterBody2D

var input
@export var speed = 200
@export var gravity = 10
@export var animator : AnimatedSprite2D
@export var tomato_scene: PackedScene
var facing_right = true
var tomato_timer = 0.0
@export var throw_interval = 0.5  # 每 1.5 秒扔一次
var is_game_over : bool = false
var throw_direction := Vector2.RIGHT
var tomato_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_game_over:
		movement(delta)

		if Input.is_action_just_pressed("shoot"):
			var mouse_pos = get_global_mouse_position()
			throw_direction = (mouse_pos - global_position).normalized()
			$AnimatedSprite2D.scale.x = sign(throw_direction.x)
		
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

	#if facing_right:
		#tomato.velocity = Vector2(300, -400)
	#else:
		#tomato.velocity = Vector2(-300, -400)
		
	
		

	get_parent().add_child(tomato)
	#var mouse_pos = get_global_mouse_position()
	#var direction = (mouse_pos - global_position).normalized()
	
	# 设置速度大小

	tomato.velocity = throw_direction * tomato_speed


func game_over():
	if not is_game_over:
		is_game_over = true
		animator.play("death")
		
		#get_tree().current_scene.show_game_over()
		#$GameOverSound.play()
		
		# 重启游戏 - 会导致白光
		#await get_tree().create_timer(3).timeout
		#get_tree().reload_current_scene()
		
		#$RestartTimer.start()
		
