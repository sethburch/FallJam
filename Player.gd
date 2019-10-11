extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = Vector2(0, 1500)
const MAX_FALL_SPEED = Vector2(0, 1500)
const JUMP_SPEED = 450
const JUMP_HEIGHT = 900
const ACCELERATION = 50
const AIR_ACCELERATION = 30
const MAX_SPEED = 200
const MAX_DASH_SPEED = 1500
const AIR_FRICTION = 0.05
const GROUND_FRICTION = .3
const JUMP_FALLOFF_SPEED = .5
const JUMP_BUFFER_MAX = 6

var motion = Vector2()
var friction = false

var anim = ""
var new_anim = ""
var facing_right = true
var coyote_jump_buffer = 0
var jump_buffer = 0
var has_jumped = false

var haxis = 1
var vaxis = 0
var player_dir = haxis

func _ready():
	add_to_group("Player")

func _physics_process(delta):
	haxis = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	vaxis = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if haxis != 0:
		player_dir = haxis

	#add gravity if we havent reached max fall speed yet
	if motion.y < MAX_FALL_SPEED.y:
		motion += delta * GRAVITY
	
	#move
	motion = move_and_slide(motion, UP)

	#jumping with buffer
	if is_on_floor():
		coyote_jump_buffer = 0
		if !has_jumped and jump_buffer < JUMP_BUFFER_MAX:
			jump_buffer = JUMP_BUFFER_MAX
			has_jumped = true
			motion.y = -JUMP_SPEED
			new_anim = "jump_inital"
	jump_buffer+=1
		
	#jumping with coyote time
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0
		if !has_jumped and coyote_jump_buffer < JUMP_BUFFER_MAX:
			coyote_jump_buffer = JUMP_BUFFER_MAX
			has_jumped = true
			motion.y = -JUMP_SPEED
			new_anim = "jump_inital"
	coyote_jump_buffer+=1

	#if we release the jump key while rising then cut off the jump
	if Input.is_action_just_released("jump"):
		has_jumped = false
		#if we're falling
		if motion.y < 0:
			motion.y = lerp(motion.y, 0, JUMP_FALLOFF_SPEED)
			new_anim = "jump_peak"

	#play jump animations
	if !is_on_floor():
		if motion.y > -100 and motion.y < 100:
			new_anim = "jump_peak"
		elif motion.y < 0 and motion.y > -JUMP_SPEED+100:
			new_anim = "jump_rise"
		elif motion.y > 0:
			new_anim = "jump_fall"
			
	#movement on ground
	if is_on_floor():
		if Input.is_action_pressed("move_right"):
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			if motion.x < ACCELERATION*4:
				new_anim = "run_inital"
			else:
				new_anim = "run"
			facing_right = true
			friction = false
		elif Input.is_action_pressed("move_left"):
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			if motion.x > -ACCELERATION*4:
				new_anim = "run_inital"
			else:
				new_anim = "run"
			facing_right = false
			friction = false
		else:
			friction = true
	#movement in air
	else:
		if Input.is_action_pressed("move_right"):
			motion.x = min(motion.x+AIR_ACCELERATION, MAX_SPEED)
			facing_right = true
			friction = false
		elif Input.is_action_pressed("move_left"):
			motion.x = max(motion.x-AIR_ACCELERATION, -MAX_SPEED)
			facing_right = false
			friction = false
		else:
			friction = true

	#deceleration
	if is_on_floor():
		if friction:
			motion.x = lerp(motion.x, 0, GROUND_FRICTION)
	else:
		if friction:
			motion.x = lerp(motion.x, 0, AIR_FRICTION)