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



#func _on_area_entered(area: Area2D) -> void:
	#print("敌人检测到碰撞：", area.name, " 所属组 Tomato？", area.is_in_group("Tomato"))
#
	#if is_dead:
		#return  # 防止多次触发
#
	#if area.is_in_group("Tomato"):
		#is_dead = true
		#area.queue_free()
#
		## 播放死亡动画
		#$AnimatedSprite2D.play("death")
		#
		## 可选：播放音效、爆炸粒子
		## $DeathSound.play()
		## spawn_tomato_juice_effect()
#
		## 等待动画播完后销毁自己
		#await $AnimatedSprite2D.animation_finished
		#queue_free()
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Tomato"):
		$AnimatedSprite2D.play("death")
		is_dead = true
		area.queue_free()
		#get_tree().current_scene.score += 1
		
		await get_tree().create_timer(0.6).timeout
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	
	if body is CharacterBody2D and not is_dead:
		print("entered and player")
		body.game_over()
