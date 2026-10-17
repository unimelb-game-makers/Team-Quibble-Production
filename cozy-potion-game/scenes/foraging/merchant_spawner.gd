class_name MerchantSpawner extends Node

@export var markers: Array[Marker3D]
@export var polygons: Array[Area3D]
@export var merchant: WorldMerchant
@export var forest: Node3D


func _ready() -> void:
	for i in range(polygons.size()):
		polygons[i].body_entered.connect(_on_body_enter.bind(i))

func _on_body_enter(body, id) -> void:
	if body is WorldPlayer:
		spawn_merchant(id)

func spawn_merchant(id: int) -> void:
	merchant.global_position = Utils.get_marker_ground_pos(markers[id])
	queue_free()
