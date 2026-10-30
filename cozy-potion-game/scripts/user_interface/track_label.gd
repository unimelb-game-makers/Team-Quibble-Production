class_name TrackLabel extends Label

@export var base_text: String:
	set(value):
		value = "   " + value + "   "
		base_text = value
		text = base_text

var offset: int


func _process(delta: float) -> void:
	if base_text.length() > 50:
		offset = Time.get_ticks_msec() / 500
		
		var new_word: String = base_text
		
		for i in range(base_text.length()):
			var placement = (i - offset) % base_text.length()
			new_word[placement] = base_text[i]
		
		text = new_word
