#extends Node2D
#
#@export var text_wave_scene: PackedScene = preload("res://Scenes/TextWave.tscn")
#@export var sentence: String = "AI STRATEGY ROAD MAP MATURITY"
#@export var fire_interval: float = 3.0
#@export var fire_direction: Vector2 = Vector2.LEFT
#
#func _ready():
	#$TextBurstTimer.wait_time = fire_interval
	#$TextBurstTimer.timeout.connect(_on_TextBurstTimer_timeout)
	#$TextBurstTimer.start()
#
	## 朝左（可选，如果你使用 flip_h 来设置方向）
	##$Sprite.flip_h = true
#
#func _on_TextBurstTimer_timeout():
	#spawn_text_wave()
#
#func spawn_text_wave():
	#var wave = text_wave_scene.instantiate()
	#wave.position = $TextSpawnPoint.global_position
	#wave.set_direction(fire_direction)
	#wave.sentence = sentence  # 设置句子内容
	#get_tree().current_scene.add_child(wave)
#extends Node2D
#
#@export var text_wave_scene: PackedScene = preload("res://Scenes/TextWave.tscn")
#@export var sentences: Array[String] = [
	#"AI STRATEGY ROAD MAP MATURITY",
	#"YOU DON'T EVEN HAVE A GPU",
	#"YOUR DATASET IS FROM 2012",
	#"YOU FINE-TUNED ON STACKOVERFLOW",
	#"YOUR LOSS CURVE NEVER CONVERGED",
	#"YOUR PROMPT IS TOO LONG TO CARE"
#]
#@export var fire_interval: float = 3.0
#@export var fire_direction: Vector2 = Vector2.LEFT
#
#var current_sentence_index := 0
#
#func _ready():
	#$TextBurstTimer.wait_time = fire_interval
	#$TextBurstTimer.timeout.connect(_on_TextBurstTimer_timeout)
	#$TextBurstTimer.start()
#
#func _on_TextBurstTimer_timeout():
	#spawn_text_wave()
#
#func spawn_text_wave():
	#var wave = text_wave_scene.instantiate()
	#wave.position = $TextSpawnPoint.global_position
	#wave.set_direction(fire_direction)
	#wave.sentence = sentences[current_sentence_index]
	#get_tree().current_scene.add_child(wave)
#
	## 播完一条，换下一句
	#current_sentence_index += 1
	#if current_sentence_index >= sentences.size():
		#current_sentence_index = 0
		
extends Node2D
@export var projectile_scene: PackedScene = preload("res://Scenes/TextWave.tscn")
@export var attack_words: Array[String] = [
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
@export var launch_interval: float = 2

func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	
func _on_TextBurstTimer_timeout():
	launch_word_wave()

func launch_word_wave():
	call_deferred("_launch_words", attack_words, 0)

func _launch_words(words: Array[String], index: int):
	if index >= words.size():
		return


	var proj = projectile_scene.instantiate()
	
	
	var is_facing_left = $AnimatedSprite2D.flip_h
	var dir := 1
	if is_facing_left:
		dir = -1
	
	proj.position = $TextSpawnPoint.global_position
	proj.set_text(words[index])
	proj.initial_velocity = Vector2(randf_range(50, 100) * dir, randf_range(-150, -200))
	get_tree().current_scene.add_child(proj)

	var timer = Timer.new()
	timer.wait_time = launch_interval
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func ():
		_launch_words(words, index + 1)
		timer.queue_free()
	)
	timer.start()
