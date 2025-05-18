extends Node2D

@export var text_bullet_scene: PackedScene
@export var fire_rate: float = 2.0
@export var max_health: int = 10
var health: int = 10
var is_dead := false
var can_shoot := true
@export var sentences: = [
	"ALIGNMENT",
	"STRATEGY DECK",
	"CLIENT FEEDBACK",
	"ENGAGEMENT",
	"ACTIONABLE INSIGHTS",
	"BUSINESS VALUE",
	"STAKEHOLDER SYNC",
	"SCOPE",
	"DUE DILLIGENCE",
	"OUT OF SCOPE",
	"CHANGE REQUEST",
	"DELIVERABLES",
	"LEVERAGE THAT",
	"QUICK WIN",
	"LOW HANGING FRUIT",
	"SYNERGY",
	"QBR READY?",
	"FOLLOW-UP EMAIL",
	"ADDED TO BACKLOG",
	"PAIN POINT",
	"CAN WE ALIGN?",
	"RESOURCING CONSTRAINT",
	"GOVERNANCE MODEL",
	"LET'S TAKE THIS OFFLINE"
]
func _ready():
	if can_shoot: # add can_contrl here
		$AnimatedSprite2D.play("idle")
		$shoot_timer.wait_time = fire_rate
		$shoot_timer.timeout.connect(shoot)
		$shoot_timer.start()
		
		#print("can throw")
	


func shoot():
	if not is_instance_valid(get_tree().current_scene):
		return

	var proj = text_bullet_scene.instantiate()
	proj.global_position = global_position
	
	# 设置文字
	proj.set_text(sentences.pick_random())
	
	# 设置抛物线初速度（随机）
	var dir = -1  # 向左（你可以根据敌人朝向变成 1 向右）
	var vx = randf_range(50.0, 100.0) * dir
	var vy = randf_range(-200.0, -150.0)
	proj.initial_velocity = Vector2(vx, vy)

	get_tree().current_scene.add_child(proj)

func die():
	is_dead = true
	$AnimatedSprite2D.play("death")
	$shoot_timer.stop()

	await get_tree().create_timer(1.0).timeout
	print("🎉 Boss defeated!")
	get_tree().current_scene.level_complete()
	queue_free()
	
func take_damage(amount := 1):
	health -= amount
	health = clamp(health, 0, max_health)
	_update_progress()

	if health <= 0:
		die()
		


func _update_progress():
	var bar = get_tree().current_scene.get_node("CanvasLayer/ProgressBar")
	if bar:
		bar.value = max_health - health  # 进度 = 已造成伤害


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Tomato") and not is_dead:
		take_damage(1)
		area.queue_free()
