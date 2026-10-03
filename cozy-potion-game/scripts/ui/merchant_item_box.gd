class_name MerchantItemBox extends Control

@export var item_texture_rect: TextureRect
@export var item_name_label: Label
@export var purchase_button: Button

var item: Resource

func _ready() -> void:
	purchase_button.focus_entered.connect(on_button_hover)
	purchase_button.mouse_entered.connect(on_button_hover)
	purchase_button.focus_exited.connect(on_button_hover)
	purchase_button.mouse_exited.connect(on_button_hover)

func initialise(item: Resource):
	if item is PotionIngredient:
		self.item = item
		item_texture_rect.texture = item.ingredient_sprite
		item_name_label.text = item.ingredient_name
		purchase_button.text = "$%d" % item.ingredient_price

func on_button_hover():
	purchase_button.text = "Purchase?"

func on_button_unhover():
	purchase_button.text = "$%d" % item.ingredient_price
