tool
extends LineEdit

enum PREMADE_PATTERN {CUSTOM, DIGITS, LETTERS, ALPHANUM, URL, EMAIL}
var pattern_hint_string = "CUSTOM,DIGITS,LETTERS,ALPHANUM,URL,EMAIL"

var use_regex: bool = true

# This will be shown only if use_regex if true
var premade_pattern = PREMADE_PATTERN.DIGITS
# This will be shown only if predefined pattern is not custom
var prevent_typing: bool = true
# This will be shown only if only use_regex is true and predefined pattern is custom
var regex_pattern: String = ""

var pattern_dict = {
	PREMADE_PATTERN.CUSTOM: "",
	PREMADE_PATTERN.DIGITS: "[0-9]+",
	PREMADE_PATTERN.LETTERS: "[a-zA-Z]+",
	PREMADE_PATTERN.ALPHANUM: "[a-zA-Z0-9]+",
	PREMADE_PATTERN.URL: "^(?:http(s)?:\\/\\/)?[\\w.-]+(?:\\.[\\w\\.-]+)+[\\w\\-\\._~:\\/?#[\\]@!\\$&'\\(\\)\\*\\+,;=.]+$",
	PREMADE_PATTERN.EMAIL: "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
	# Email regex: https://emailregex.com/
}

var regex = RegEx.new()

func _ready() -> void:
	if !use_regex: return
	
#This is where you add your properties
func _get_property_list() -> Array:
	var properties := Array()
	properties.append({
		name = "Use Regex",
		type = TYPE_BOOL,
		usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	if use_regex:
		properties.append({
			name = "Predefined pattern",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = pattern_hint_string,
			usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		})
	if use_regex && premade_pattern != PREMADE_PATTERN.CUSTOM:
		properties.append({
			name = "Prevent typing",
			type = TYPE_BOOL,
			hint_tooltip = "Reject characters not fitting the Regex",
			usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		})
		properties.append({
			name = "Pattern",
			type = TYPE_STRING,
			usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		})
	if use_regex && premade_pattern == PREMADE_PATTERN.CUSTOM:
		properties.append({
			name = "Custom pattern",
			type = TYPE_STRING,
			usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		})
	return properties
	
func _set(property: String, value) -> bool:
	match property:
		"Use Regex":
			use_regex = value
			if use_regex:
				if !is_connected("text_changed", self, "on_text_changed"):
					connect("text_changed", self, "on_text_changed")
			else:
				disconnect("text_changed", self, "on_text_changed")
			compile_regex(regex_pattern)
			property_list_changed_notify()
			return true
		"Predefined pattern":
			premade_pattern = value
			if premade_pattern == PREMADE_PATTERN.CUSTOM:
				regex_pattern = ""
			else:
				regex_pattern = pattern_dict[premade_pattern]
			
			# Prevent tpying only for certain pattern
			prevent_typing = premade_pattern in [PREMADE_PATTERN.ALPHANUM, PREMADE_PATTERN.DIGITS, PREMADE_PATTERN.LETTERS]
		
			compile_regex(regex_pattern)
			property_list_changed_notify()
			return true
		"Prevent typing":
			prevent_typing = value
			return true
		"Pattern":
			regex_pattern = value
			compile_regex(regex_pattern)
			return true
		"Custom pattern":
			regex_pattern = value
			compile_regex(regex_pattern)
			return true
		_ :
			return false
			
func _get(property: String):
	match property:
		"Use Regex":
			return use_regex
		"Predefined pattern":
			return premade_pattern
		"Prevent typing":
			return prevent_typing
		"Pattern":
			return regex_pattern
		"Custom pattern":
			return regex_pattern
			
	return null

func compile_regex(pattern: String) -> void:
	var err = regex.compile(regex_pattern)
	if err != OK:
		print("Error compiling the RegEx: %s" %err)

func run_regex() -> bool:
	return regex.search(text) != null

func on_text_changed(txt: String) -> void:
	if !use_regex || !prevent_typing: return
	var old_caret_pos = caret_position
	var res = regex.search(txt)
	if !res: 
		text = ""
		caret_position = old_caret_pos
		return
	text = PoolStringArray(res.strings).join("")
	caret_position = old_caret_pos
