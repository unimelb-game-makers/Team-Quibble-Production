extends Node

enum {
	TREE_MNGR,
	BUSH_MNGR,
	GROUND_MNGR,
	CAVE_MNGR,
	KELP_MNGR,
}

@export var tree_manager: FoliageManager
@export var bush_manager: FoliageManager
@export var ground_manager: FoliageManager
@export var cave_manager: FoliageManager
@export var kelp_manager: FoliageManager

var foliage_managers: Array[FoliageManager]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	foliage_managers.resize(5)
	foliage_managers[TREE_MNGR] = tree_manager
	foliage_managers[BUSH_MNGR] = bush_manager
	foliage_managers[GROUND_MNGR] = ground_manager
	foliage_managers[CAVE_MNGR] = cave_manager
	foliage_managers[KELP_MNGR] = kelp_manager

	NewsManager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
