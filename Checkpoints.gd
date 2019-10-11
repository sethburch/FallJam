extends Node2D

func _ready():
	for i in get_child_count():
		var child = get_child(i)
		child.add_to_group("Checkpoint")