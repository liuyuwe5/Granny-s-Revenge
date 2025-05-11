#extends Area2D
#
#@export var sentence: String = "AI STRATEGY ROAD MAP MATURITY"
#@export var letter_scene: PackedScene = preload("res://Scenes/FloatingLetter.tscn")
#@export var spacing: Vector2 = Vector2(-20, 0)
#@export var direction: Vector2 = Vector2(-1, 0)
#
#func _ready():
	#$TextBurstTimer.start()
#
#func spawn_text_burst():
	#print("start spawn text")
	#var start_pos = $TextSpawnPoint.global_position
	#var letter_index := 0
	#for char in sentence:
		#if char == " ":
			#continue
		#var letter = letter_scene.instantiate()
		#letter.set_text(char)
		#letter.position = start_pos + spacing * letter_index
		#letter.set_direction(direction)
		#get_tree().current_scene.add_child(letter)
		#letter_index += 1
#
#func _on_TextBurstTimer_timeout() -> void:
	#spawn_text_burst()
	
	
	
extends Area2D

@export var sentence: String = "AI STRATEGY ROAD MAP MATURITY"
@export var letter_scene: PackedScene = preload("res://Scenes/FloatingLetter.tscn")
@export var spacing: Vector2 = Vector2(-20, 0)
@export var direction: Vector2 = Vector2(-1, 0)
@export var delay_between_letters: float = 0.1

func _ready():
	$TextBurstTimer.timeout.connect(_on_TextBurstTimer_timeout)
	$TextBurstTimer.start()

func _on_TextBurstTimer_timeout():
	start_text_sequence()

func start_text_sequence():
	var start_pos = $TextSpawnPoint.global_position
	call_deferred("_spawn_next_letter", sentence, start_pos, 0)
#
#func _spawn_next_letter(text: String, start_pos: Vector2, index: int):
	#if index >= text.length():
		#return
#
	#var char = text[index]
	#if char != " ":
		#var letter = letter_scene.instantiate()
		#letter.set_text(char)
		#letter.position = start_pos - spacing * index
		#letter.set_direction(direction)
		#get_tree().current_scene.add_child(letter)
#
	#var timer = Timer.new()
	#timer.one_shot = true
	#timer.wait_time = delay_between_letters
	#add_child(timer)
#
	#timer.timeout.connect(func ():
		#_spawn_next_letter(text, start_pos, index + 1)
		#timer.queue_free()
	#)
	#timer.start()
	
func _spawn_next_letter(text: String, start_pos: Vector2, index: int):
	if index >= text.length():
		return
	
	var char = text[index]
	if char != " ":
		var letter = letter_scene.instantiate()
		letter.set_text(char)
		letter.position = start_pos + spacing * index
		letter.set_direction(direction)
		get_tree().current_scene.add_child(letter)

	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = delay_between_letters
	add_child(timer)

	timer.timeout.connect(func ():
		_spawn_next_letter(text, start_pos, index + 1)
		timer.queue_free()
	)
	timer.start()
