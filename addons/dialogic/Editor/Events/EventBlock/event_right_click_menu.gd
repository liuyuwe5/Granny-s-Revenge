@tool
extends PopupMenu

var current_event: Node = null

func _ready() -> void:
	clear()
	add_icon_item(get_theme_icon("Duplicate", "EditorIcons"), "Duplicate", 0)
	add_separator()
	add_icon_item(get_theme_icon("PlayStart", "EditorIcons"), "Play from here", 1)
	add_separator()
	add_icon_item(get_theme_icon("Help", "EditorIcons"), "Documentation", 2)
	add_icon_item(get_theme_icon("CodeHighlighter", "EditorIcons"), "Open Code", 3)
	add_separator()
	add_icon_item(get_theme_icon("ArrowUp", "EditorIcons"), "Move up", 4)
	add_icon_item(get_theme_icon("ArrowDown", "EditorIcons"), "Move down", 5)
	add_separator()
	add_icon_item(get_theme_icon("Remove", "EditorIcons"), "Delete", 6)

	var menu_background := StyleBoxFlat.new()
	menu_background.bg_color = get_parent().get_theme_color("base_color", "Editor")
	add_theme_stylebox_override('panel', menu_background)
	add_theme_stylebox_override('hover', get_theme_stylebox("FocusViewport", "EditorStyles"))
	add_theme_color_override('font_color_hover', get_parent().get_theme_color("accent_color", "Editor"))
