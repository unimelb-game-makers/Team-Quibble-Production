class_name MerchantItemBox extends Control

@export var item_texture_rect: TextureRect
@export var item_name_label: Label
@export var purchase_button: Button

var item_price: int
var sold: bool = false
var item: Resource = PotionIngredient.new()

func _ready() -> void:
	purchase_button.focus_entered.connect(on_button_hover)
	purchase_button.mouse_entered.connect(on_button_hover)
	purchase_button.focus_exited.connect(on_button_unhover)
	purchase_button.mouse_exited.connect(on_button_unhover)
	purchase_button.pressed.connect(on_button_pressed)

func initialise(item: Resource) -> void:
	if item is PotionIngredient:
		self.item = item
		self.item_price = item.ingredient_price
		item_texture_rect.texture = item.ingredient_sprite
		item_name_label.text = item.ingredient_name
		purchase_button.text = "$%d" % item.ingredient_price

func purchase_item() -> void:
	var bag: ForagingBag = get_tree().get_first_node_in_group(Utils.Group.GROUP_FORAGING_BAG)
	var stack: Stack = Stack.new(3, item)
	bag.hover_inventory.inventory.blind_add_stack(stack)
	
	purchase_button.disabled = true
	item_texture_rect.modulate = Color.DARK_GRAY
	purchase_button.text = "Sold!"
	
	sold = true

func on_button_pressed() -> void:
	if PersistentInventory.money > item_price:
		PersistentInventory.money -= item_price
		purchase_item()
	else:
		animate_button_refuse(purchase_button)

func animate_button_refuse(control: Control):
	var tween = control.get_tree().create_tween()
	tween.tween_property(control, "modulate", Color(1,.6,.6, 1), 0.1)
	tween.tween_property(control, "modulate", Color(1,1,1,1), 0.1)
	await control.get_tree().create_timer(0.2).timeout
	return

func on_button_hover() -> void:
	if not sold:
		purchase_button.text = "Purchase?"

func on_button_unhover() -> void:
	if not sold:
		purchase_button.text = "$%d" % item.ingredient_price
