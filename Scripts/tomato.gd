extends Area2D

@export var velocity = Vector2(600, -400)
@export var gravity_tomato = 80  # 每秒加速度，手动模拟下落
var exploded = false

func _ready():
	await get_tree().create_timer(0.1).timeout  # 0.1 秒延迟
	connect("body_entered", _on_body_entered)
	$AnimatedSprite2D.play("fly")

func _process(delta):
	if exploded:
		return
	
	velocity.y += gravity_tomato * delta
	position += velocity * delta * 2

func _on_body_entered(body):
	if exploded or body == owner:
		return
	exploded = true
	$AnimatedSprite2D.play("explosion")
	await $AnimatedSprite2D.animation_finished
	queue_free()
