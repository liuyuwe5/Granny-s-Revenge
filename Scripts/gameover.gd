extends Control


@onready var quit_button = $Quit
@onready var restart_button = $Restart
@onready var title_label = $TitleLabel
#@onready var tween = create_tween()

var death_titles = [
	"勇敢的理想主义者",
	"血色黎明的追随者",
	"坚韧的乌托邦筑梦人",
	"社会主义铁拳的传人",
	"现实中的浪漫斗士",
	"反叛的诗人",
	"暴风雨前的火种",
	"被钞票碾过的英雄",
	"资本废墟上的花朵"
]

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var title = death_titles[randi() % death_titles.size()]
	#title_label.text = title
	#
	#restart_button.pressed.connect(on_restart_pressed)
	#quit_button.pressed.connect(on_quit_pressed)
	#
	##
##func _process(delta: float) -> void:
	#var parent_width = get_viewport_rect().size.x
	#title_label.position.x = (parent_width - title_label.size.x) / 2
	#title_label.visible = true
	#
	

func _ready() -> void:
	# 随机选择称号
	var title = death_titles[randi() % death_titles.size()]
	title_label.text = title

	# 把 label 位置先放到屏幕右边外面
	await get_tree().process_frame  # 等待一帧以确保大小更新
	var screen_width = get_viewport_rect().size.x
	var target_x = (screen_width - title_label.size.x) / 2
	title_label.position.x = screen_width + 100  # 超出屏幕一点

	# 动画移动到中间
	var tween = create_tween()
	tween.tween_property(
		title_label, "position:x", target_x, 0.8
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# 连接按钮
	restart_button.pressed.connect(on_restart_pressed)
	quit_button.pressed.connect(on_quit_pressed)	

#
#func _process(delta):
	#center_title()
	#
#func center_title():
	#var parent_width = get_viewport_rect().size.x
	#var target_x = (parent_width - title_label.size.x) / 2
	#tween.tween_property(title_label, "position:x", target_x, 0.3)
	
func on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Intro.tscn")
	
	
func  on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
