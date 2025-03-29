extends CharacterBody2D

var input
@export var speed = 200
@export var gravity = 10
@export var animator : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement(delta)
	
func movement(_delta):
	input = Input.get_action_strength("right") - Input.get_action_strength("left") 
	if input != 0:
		if input>0:
			velocity.x = speed
			$AnimatedSprite2D.scale.x = 1
			animator.play("walk")
		elif input < 0:
			velocity.x = -speed
			$AnimatedSprite2D.scale.x = -1
			animator.play("walk")
	if input == 0:
		velocity.x = 0
		animator.play("idle")
		
	velocity.y += gravity
	move_and_slide()
	#velocity = Input.get_vector("left","right","","") * speed
	#if velocity == Vector2.ZERO:
		#animator.play("idle")
	#else:
		#animator.play("walk")
	#move_and_slide()

	#
	
	
	
