extends Control

func _ready() -> void:
	pass

func _on_Run_pressed() -> void:
	var res = $"VBoxContainer/HBoxContainer/LineEdit+".run_regex()
	print(res)
	$VBoxContainer/HBoxContainer2/Result.text = str(res)


func _on_LineEdit_regex_result(result, txt) -> void:
	if !result:
		$"VBoxContainer/HBoxContainer3/LineEdit+".set("custom_colors/font_color", Color(1.0, 0, 0))
	else:
		$"VBoxContainer/HBoxContainer3/LineEdit+".set("custom_colors/font_color", Color(1.0, 1.0, 1.0))
