extends Node

enum TILES {BLUE, RED}

export(float) var switch_time = 120.0
var current_color = TILES.BLUE
var switch_timer : float = 0.0

var red_enabled = true
var blue_enabled = false

var red_player = preload("res://RedPlayer.tres")
var blue_player = preload("res://BluePlayer.tres")

#var song = preload("res://sound/main_theme2.wav")

var previous_delta : float = -1.0

var start_timer = true

var time_begin
var time_delay

var game_start = false

func _ready():
#	var timer = Timer.new()
#	timer.name = "Timer"
#	timer.process_mode = Timer.TIMER_PROCESS_IDLE
#	add_child(timer)
	$Music.play()

func _physics_process(delta):
#	switch_timer+=1.0*(((previous_delta-delta)/1000000.0)+1.0)
#	if switch_timer >= 120.0:
#		switch_timer = 0.0
#		_switch()
#	previous_delta = delta
#	if start_timer:
#		$Music.play()
#		start_timer = false
#		_switch()
#	switch_timer+=1.0
#	if switch_timer >= 119.0:
#		switch_timer = 0.0
#		_switch()
##	switch_timer+=1
##	if switch_timer >= 119:
##		switch_timer = 0
##		_switch()
#	switch_timer+=(1.0*(((previous_delta-delta)/1000000.0)+1.0))
#	print_debug(switch_timer)
#	if switch_timer >= 59.0:
#		switch_timer = 0.0
#		_switch()
#	previous_delta = delta
	pass

func _process(delta):
#	var dt = -1.0
#	if previous_delta == -1.0:
#		dt = 1.0
#	else:
#		dt = previous_delta - delta
#	get_node("Timer").wait_time = get_node("Timer").wait_time+(dt/1000000.0)
#	print_debug(get_node("Timer").wait_time)
#	previous_delta = delta
##		$GameTimer.wait_time = switch_time+(previous_delta - delta)
##		print_debug($GameTimer.wait_time)
##		previous_delta = delta
	if !game_start and Input.is_action_just_pressed("jump"):
		game_start = true
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func _switch():
	red_enabled = !red_enabled
	blue_enabled = !blue_enabled
	if red_enabled:
		$CurrentLevel.enable_red(true)
		$Player/Sprite.frames = red_player
	if !red_enabled:
		$CurrentLevel.enable_red(false)
	if blue_enabled:
		$CurrentLevel.enable_blue(true)
		$Player/Sprite.frames = blue_player
	if !blue_enabled:
		$CurrentLevel.enable_blue(false)

func update_level():
	if red_enabled:
		$CurrentLevel.enable_red(true)
	if !red_enabled:
		$CurrentLevel.enable_red(false)
	if blue_enabled:
		$CurrentLevel.enable_blue(true)
	if !blue_enabled:
		$CurrentLevel.enable_blue(false)

#func _on_GameTimer_timeout():
#	_switch()
	
func set_key_count(count):
	$CanvasLayer/GUI/Label.text = str(count) + "/7"

func _on_GameTimer_timeout():
	if !$Music.is_playing():
		$Music.play()
	_switch()
