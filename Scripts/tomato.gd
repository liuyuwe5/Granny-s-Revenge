extends RigidBody2D

@export var initial_velocity = Vector2(300, -400)

var exploded = false  # 防止多次触发

func _ready():
	linear_velocity = initial_velocity
	$Area2D.connect("body_entered", _on_area_body_entered)
	$AnimatedSprite2D.play("fly")  # 起飞动画

func _on_area_body_entered(body):
	if exploded:
		return
	if body.is_in_group("enemy"):
		print("番茄砸中敌人！Boom💥")
		exploded = true
		show_explosion()

func show_explosion():
	$AnimatedSprite2D.play("explosion")
	
	await $AnimatedSprite2D.animation_finished
	queue_free()
