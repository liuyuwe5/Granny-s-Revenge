extends Node2D

@onready var dialog_timer = $DialogTimer  # A Timer node with Autostart OFF
@onready var player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.win_scene = true
	dialog_timer.start(2.0)  # Wait 2 seconds before dialog
	dialog_timer.timeout.connect(_on_dialog_timer_timeout)
	Dialogic.timeline_ended.connect(_on_dialog_ended)

func _on_dialog_timer_timeout():
	player.can_control = false  # Stop movement and actions
	Dialogic.start("final_scene_intro")  # Replace with your Dialogic timeline name

func _on_dialog_ended():
	player.can_control = true  # Restore movement
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
