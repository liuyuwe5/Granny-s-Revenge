extends Area2D

@export var speed := 100
var direction := -1  # -1 = 向左，1 = 向右

func _process(delta):
	position.x += direction * speed * delta

	# 播放对应动画
	if direction > 0:
		$AnimatedSprite2D.play("walk_right")
	else:
		$AnimatedSprite2D.play("walk_left")
