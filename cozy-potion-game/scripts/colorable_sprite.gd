class_name ColorableSprite extends Sprite2D

@onready var uncolored: Sprite2D = $Uncolored

func set_colored_texture(_new_texture: Texture) -> void:
	set_texture(_new_texture)

func set_uncolored_texture(_new_texture: Texture) -> void:
	uncolored.set_texture(_new_texture)

func set_color(_new_color: Color) -> void:
	self_modulate = _new_color

func set_as_item(_item: Stack) -> void:
	## TODO: make the appropriate variables in Stack
	pass
