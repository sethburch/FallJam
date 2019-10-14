extends Node2D
onready var current_level = get_node("Level1")

var switch_timer : float = 0.0

var final_time : int = 0

var open_door = preload("res://sound/open_door.wav")

func _ready():
	#get_parent().get_node("Music").play()
	pass
	#$GameTimer.start()
	
#func _physics_process(delta):
#	switch_timer += (1.0+(delta/60.0))
#	if switch_timer >= 120.0:
#		switch_timer = 0
#		get_parent()._switch()



func enable_red(enable):
	if enable:
		current_level.current_bg.modulate = Color("#d35a5a")
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
		current_level.current_bg.modulate = Color("#52a4a4")
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

func _physics_process(delta):
	if get_parent().game_start:
		final_time+=1

func _process(delta):
	if current_level == get_node("Level1"):
		if get_parent().get_node("Player").key_count >= 7:
			current_level.get_node("Door").open()
			get_parent().get_node("Sound").stream = open_door
			get_parent().get_node("Sound").play()
			set_process(false)

	
#func _on_GameTimer_timeout():
#	get_parent()._switch()
