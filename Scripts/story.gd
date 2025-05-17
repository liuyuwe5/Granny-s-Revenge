extends Node2D

@export var timeline_name: String 
@export var next_scene_path: String 


func _ready():
	Dialogic.start(timeline_name)
	Dialogic.timeline_ended.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	get_tree().change_scene_to_file(next_scene_path)
