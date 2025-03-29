extends Area2D

@export var speed := 100
var direction := -1  # -1 = 向左，1 = 向右
var is_dead := false

func _process(delta):
	if is_dead:
		return
	
	position.x += direction * speed * delta
	
	# 播放统一 walk 动画
	$AnimatedSprite2D.play("walk")
	
	# 控制左右翻转（面朝方向）
	$AnimatedSprite2D.scale.x = direction
