extends RigidBody2D

@export var initial_velocity = Vector2(300, -400)

func _ready():
	linear_velocity = initial_velocity
	$Area2D.connect("body_entered", _on_area_body_entered)

func _on_area_body_entered(body):
	if body.is_in_group("enemy"):
		print("砸到了敌人！Boom💥")
		show_explosion()
		queue_free()
		
		
func show_explosion():
	play("explosion")
