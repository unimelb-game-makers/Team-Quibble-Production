class_name NotebookItemArray
extends GridContainer

signal item_clicked(holder: ItemHolder)

var currently_displayed: ItemHolder = null
var current_page : int = 0

@export var cols: int = 1
@export var rows: int = 1

func _ready() -> void:
	columns = cols
	
	change_item_page(0)


# Returns array of items expected in a page
func get_items_from_page(page_num: int) -> Array[PotionIngredient]:
	if page_num < 0:
		return []
	
	var items: Array[PotionIngredient] = []
	var start := page_num*cols*rows
	var end : int = min((page_num + 1)*cols*rows, Alchemy.ingredient_list.size())
	
	for i in range(start, end):
		items.append(Alchemy.ingredient_list[i])
	
	return items

const ITEM_HOLDER_SCENE = preload("uid://80sdcv4hsqa1")


func create_item(ingre : PotionIngredient) -> ItemHolder:
	var new := ITEM_HOLDER_SCENE.instantiate()
	add_child(new)
	new.stack = Stack.new(1, ingre)
	return new


# Removes all items and puts new ones in their place
func change_item_page(page_num : int) -> void:
	var items := get_items_from_page(page_num)
	if items.size() == 0:
		return
	
	current_page = page_num
	
	# Remove previous items
	for child in get_children():
		child.queue_free()
	
	# Add items to page
	for item in items:
		var instance := create_item(item)
		instance.gui_input.connect(item_input.bind(instance))
		instance.draggable_component.queue_free()
		instance.mouse_filter = Control.MOUSE_FILTER_PASS


func item_input(event: InputEvent, holder : ItemHolder) -> void:
	if event.is_action_pressed("LMB"):
		if currently_displayed != null:
			currently_displayed.highlight_turn_off()
		
		currently_displayed = holder
		holder.highlight_turn_on()
		
		item_clicked.emit(currently_displayed)
