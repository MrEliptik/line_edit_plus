tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("LineEdit+", "LineEdit", preload("line_edit_node.gd"), preload("line_edit_icon.png"))

func _exit_tree() -> void:
	remove_custom_type("LineEdit+")
