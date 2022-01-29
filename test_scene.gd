extends Control

func _ready() -> void:
	pass

func _on_Run_pressed() -> void:
	var res = $"VBoxContainer/HBoxContainer/LineEdit+".run_regex()
	print(res)
	$VBoxContainer/HBoxContainer2/Result.text = str(res)
