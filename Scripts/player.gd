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
var can_control := true  # Control whether the player can move/shoot
var win_scene:= false # if in win scene
var can_throw := true
@export var max_hearts := 3
var current_hearts := 3
@export var full_heart_texture: Texture
@export var empty_heart_texture: Texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_hearts_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_game_over and can_control and can_throw: # add can_contrl here
		movement(delta)
		
		if win_scene:
			return # stop here
		
		if Input.is_action_just_pressed("shoot"):
			var mouse_pos = get_global_mouse_position()
			throw_direction = (mouse_pos - global_position).normalized()
			$AnimatedSprite2D.scale.x = sign(throw_direction.x)
		
		tomato_timer += delta
		if tomato_timer > throw_interval:
			tomato_timer = 0
			throw_tomato()
		#print("can throw")
	elif not is_game_over and can_control:
		movement(delta)
		#print("can't throw")
		
	
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

	get_parent().add_child(tomato)
	#var mouse_pos = get_global_mouse_position()
	#var direction = (mouse_pos - global_position).normalized()
	
	# 设置速度大小

	tomato.velocity = throw_direction * tomato_speed

func take_damage():
	if is_game_over:
		return

	current_hearts -= 1
	update_hearts_ui()

	if current_hearts <= 0:
		
		game_over()

func update_hearts_ui():
	var container = get_tree().current_scene.get_node("CanvasLayer/HeartContainer")
	for i in range(max_hearts):
		var heart = container.get_child(i)
		if i < current_hearts:
			heart.texture = full_heart_texture
		else:
			heart.texture = empty_heart_texture

#
func game_over():
	if not is_game_over:
		is_game_over = true
		animator.play("death")
		await get_tree().create_timer(3).timeout
		print("change_scene")
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
		print("✅ done")

		
		
func win():
	if not is_game_over:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/Win.tscn")

		
