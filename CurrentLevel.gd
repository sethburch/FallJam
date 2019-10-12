extends Node2D
onready var current_level = get_node("Level1")

func enable_red(enable):
	if enable:
		current_level.get_node("RedTiles").tile_set.tile_set_texture(0, load("res://red_enabled.png"))
		current_level.get_node("RedTiles").set_collision_layer_bit(0, 1)
		current_level.get_node("RedTiles").set_collision_mask_bit(0, 1)
		current_level.get_node("RedHazards").tile_set.tile_set_texture(0, load("res://red_spikes_enabled.png"))
		current_level.get_node("RedHazards").set_collision_layer_bit(0, 1)
		current_level.get_node("RedHazards").set_collision_mask_bit(0, 1)
		for i in current_level.get_node("Enemies").get_child_count():
			if current_level.get_node("Enemies").get_child(i).color == "red":
				current_level.get_node("Enemies").get_child(i).enable(true)
		for i in current_level.get_node("Springs").get_child_count():
			if current_level.get_node("Springs").get_child(i).color == "red":
				current_level.get_node("Springs").get_child(i).enable(true)
	if !enable:
		current_level.get_node("RedTiles").tile_set.tile_set_texture(0, load("res://red_disabled.png"))
		current_level.get_node("RedTiles").set_collision_layer_bit(0, 0)
		current_level.get_node("RedTiles").set_collision_mask_bit(0, 0)
		current_level.get_node("RedHazards").tile_set.tile_set_texture(0, load("res://red_spikes_disabled.png"))
		current_level.get_node("RedHazards").set_collision_layer_bit(0, 0)
		current_level.get_node("RedHazards").set_collision_mask_bit(0, 0)
		for i in current_level.get_node("Enemies").get_child_count():
			if current_level.get_node("Enemies").get_child(i).color == "red":
				current_level.get_node("Enemies").get_child(i).enable(false)
		for i in current_level.get_node("Springs").get_child_count():
			if current_level.get_node("Springs").get_child(i).color == "red":
				current_level.get_node("Springs").get_child(i).enable(false)
	
func enable_blue(enable):
	if enable:
		current_level.get_node("BlueTiles").tile_set.tile_set_texture(0, load("res://blue_enabled.png"))
		current_level.get_node("BlueTiles").set_collision_layer_bit(0, 1)
		current_level.get_node("BlueTiles").set_collision_mask_bit(0, 1)
		current_level.get_node("BlueHazards").tile_set.tile_set_texture(1, load("res://blue_spikes_enabled.png"))
		current_level.get_node("BlueHazards").set_collision_layer_bit(0, 1)
		current_level.get_node("BlueHazards").set_collision_mask_bit(0, 1)
		for i in current_level.get_node("Enemies").get_child_count():
			if current_level.get_node("Enemies").get_child(i).color == "blue":
				current_level.get_node("Enemies").get_child(i).enable(true)
		for i in current_level.get_node("Springs").get_child_count():
			if current_level.get_node("Springs").get_child(i).color == "blue":
				current_level.get_node("Springs").get_child(i).enable(true)
	if !enable:
		current_level.get_node("BlueTiles").tile_set.tile_set_texture(0, load("res://blue_disabled.png"))
		current_level.get_node("BlueTiles").set_collision_layer_bit(0, 0)
		current_level.get_node("BlueTiles").set_collision_mask_bit(0, 0)
		current_level.get_node("BlueHazards").tile_set.tile_set_texture(1, load("res://blue_spikes_disabled.png"))
		current_level.get_node("BlueHazards").set_collision_layer_bit(0, 0)
		current_level.get_node("BlueHazards").set_collision_mask_bit(0, 0)
		for i in current_level.get_node("Enemies").get_child_count():
			if current_level.get_node("Enemies").get_child(i).color == "blue":
				current_level.get_node("Enemies").get_child(i).enable(false)
		for i in current_level.get_node("Springs").get_child_count():
			if current_level.get_node("Springs").get_child(i).color == "blue":
				current_level.get_node("Springs").get_child(i).enable(false)
		
func update_level(level):
	current_level = level
	get_parent().update_level()

func respawn_enemies():
	for i in current_level.get_node("Enemies").get_child_count():
		if current_level.get_node("Enemies").get_child(i).dead:
			current_level.get_node("Enemies").get_child(i).respawn_enemy()
