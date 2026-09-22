extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(teleport_player)


func teleport_player(_body: Node3D) -> void:
	if _body == get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER):
		_body.global_position = Vector3(0.0, 1.0, -3.0)
		_body.velocity = Vector3.ZERO
