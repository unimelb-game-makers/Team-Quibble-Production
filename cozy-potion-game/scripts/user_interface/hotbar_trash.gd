extends PanelContainer

@onready var drag_acceptor: DraggableAcceptorComponent = $DraggableAcceptorComponent

var item_holder: ItemHolder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drag_acceptor.accepted_draggable.connect(_on_item_moved)


func _on_item_moved(draggable: ItemHolder) -> void:
	if item_holder:
		remove_holder(true)

	item_holder = draggable
	item_holder.draggable_component.draggable_accepted.connect(remove_holder)

func remove_holder(delete_current := false) -> void:
	if !item_holder:
		return
	
	if item_holder.draggable_component.draggable_accepted.is_connected(remove_holder):
		item_holder.draggable_component.draggable_accepted.disconnect(remove_holder)
	
	if delete_current:
		item_holder.delete()
		item_holder = null