extends Node2D


func _ready():
	Dialogic.start("intro")
	Dialogic.timeline_ended.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
