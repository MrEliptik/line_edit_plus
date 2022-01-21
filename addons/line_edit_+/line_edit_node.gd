tool
extends LineEdit

enum PREMADE_PATTERN {CUSTOM, DIGITS, LETTERS, ALPHANUM, EMAIL}

export var use_regex: bool setget use_regex_set, use_regex_get
export(PREMADE_PATTERN) var premade_pattern setget premade_pattern_set, premade_pattern_get
export var regex_pattern: String = "" setget regex_pattern_set, regex_pattern_get 

var pattern_dict = {
	PREMADE_PATTERN.CUSTOM: "",
	PREMADE_PATTERN.DIGITS: "[0-9]+",
	PREMADE_PATTERN.LETTERS: "[a-zA-Z]+",
	PREMADE_PATTERN.ALPHANUM: "[a-zA-Z0-9]+",
#	PREMADE_PATTERN.URL: "^(?:http(s)?:\\/\\/)?[\\w.-]+(?:\\.[\\w\\.-]+)+[\\w\\-\\._~:\\/?#[\\]@!\\$&'\\(\\)\\*\\+,;=.]+$",
	PREMADE_PATTERN.EMAIL: "[0-9]"
}

var regex = RegEx.new()

func _ready() -> void:
	if !use_regex: return
	compile_regex(regex_pattern)
	
#This is where you add your properties
func _get_property_list() -> Array:
	var properties := Array()
	properties.append({
		name = "dummy_var",
		type = TYPE_STRING,
		usage = PROPERTY_USAGE_DEFAULT
	})
	return properties
	
func _set(property: String, value) -> bool:
	match property:
		"dummy_var" :
			return true
		_ :
			return false
		
func use_regex_set(new_val: bool) -> void:
	use_regex = new_val
	if new_val:
		if is_connected("text_changed", self, "on_text_changed"): return
		connect("text_changed", self, "on_text_changed")
		compile_regex(regex_pattern)
	else:
		disconnect("text_changed", self, "on_text_changed")
	
func use_regex_get() -> bool:
	return use_regex

func premade_pattern_set(new_val) -> void:
	premade_pattern = new_val
	print(pattern_dict[premade_pattern])
	if premade_pattern == PREMADE_PATTERN.CUSTOM: return
	regex_pattern = pattern_dict[premade_pattern]
	property_list_changed_notify()

func premade_pattern_get():
	return premade_pattern

func regex_pattern_set(new_val: String) -> void:
	regex_pattern = new_val
	premade_pattern = PREMADE_PATTERN.CUSTOM
	compile_regex(regex_pattern)
	property_list_changed_notify()
	
func regex_pattern_get() -> String:
	return regex_pattern

func compile_regex(pattern: String) -> void:
	var err = regex.compile(regex_pattern)
	if err != OK:
		print("Error compiling the RegEx: %s" %err)

func on_text_changed(txt: String) -> void:
	if !use_regex: return
	var old_caret_pos = caret_position
	var res = regex.search(txt)
	if !res: 
		text = ""
		caret_position = old_caret_pos
		return
	print(res.strings)
	text = PoolStringArray(res.strings).join("")
	caret_position = old_caret_pos
