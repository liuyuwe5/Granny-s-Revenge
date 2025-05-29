extends Area2D

@export var speed := 50
@export var health := 1
var direction := -1
var is_dead := false
var enemy_type := "small"

func configure(_speed: float, _health: int, _direction: int, _type: String):
	speed = _speed
	health = _health
	direction = _direction
	enemy_type = _type

func update_size_by_type():
	if enemy_type == "big":
		$AnimatedSprite2D.scale = Vector2(direction * 0.5, 0.5)
		$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
		var shape = $CollisionShape2D.shape as CapsuleShape2D
		shape.radius = 40
		shape.height = 90


func _process(delta):
	if is_dead:
		return

	position.x += direction * speed * delta
	
	var anim_name = get_walk_animation(enemy_type)
	$AnimatedSprite2D.play(anim_name)

	# 控制左右翻转
	
	$AnimatedSprite2D.scale = Vector2(direction, 1.0)
	if enemy_type == "big":
		update_size_by_type()

func get_walk_animation(enemy_type: String) -> String:
	match enemy_type:
		"small": return "walk_small"
		"medium": return "walk_medium"
		"big": return "walk_big"
		_: return "walk"

func get_death_animation(enemy_type: String) -> String:
	match enemy_type:
		"small": return "death_small"
		"medium": return "death_medium"
		"big": return "death_big"
		_: return "death"

func take_damage(amount: int = 1):
	if is_dead:
		return

	health -= amount
	if health <= 0:
		die()

func die():
	is_dead = true
	$AnimatedSprite2D.play(get_death_animation(enemy_type))
	print("death:" + enemy_type)

	if get_tree().current_scene.has_method("increment_score"):
		get_tree().current_scene.increment_score()

	await get_tree().create_timer(0.6).timeout
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Tomato") and not is_dead:
		take_damage(1)
		area.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_dead:
		body.take_damage()
