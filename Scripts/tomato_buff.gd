extends Area2D

@export var speed := 300
@export var target: Node2D  
var damage := 1
var exploded := false

func _ready():
	if not target:
		queue_free()
		return

	var travel_time = global_position.distance_to(target.global_position) / float(speed)

	var tween = create_tween()
	tween.tween_property(self, "global_position", target.global_position, travel_time)
	tween.tween_property(self, "rotation_degrees", 360 * travel_time, travel_time)

	await tween.finished

	if is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(damage)

	queue_free()

	
func _on_body_entered(body):
	if exploded or body == owner:
		return
	exploded = true
	$AnimatedSprite2D.play("explosion")
	await $AnimatedSprite2D.animation_finished
	queue_free()
