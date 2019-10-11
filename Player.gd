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

var current_checkpoint = null

var anim = ""
var new_anim = ""
var facing_right = true
var wall_jumped = false

var key_count = 0

var coyote_jump_buffer = 0
var jump_buffer = 0
var sticky_wall_buffer = 0
var collision_right = false
var collision_left = false
var on_wall

var has_jumped = false

var haxis = 1
var vaxis = 0
var player_dir = haxis

func _ready():
	add_to_group("Player")

func _physics_process(delta):

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("Hazards"):
			kill_player()
		
	haxis = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	vaxis = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if haxis != 0:
		player_dir = haxis

	sticky_wall_buffer-=1
	if !on_wall or is_on_floor():
		sticky_wall_buffer=0
	elif (Input.is_action_just_pressed("move_right") and collision_left) or (Input.is_action_just_pressed("move_left") and collision_right):
		sticky_wall_buffer = JUMP_BUFFER_MAX

	#add gravity if we havent reached max fall speed yet
	if on_wall:
		if motion.y < MAX_FALL_SPEED.y/20:
			motion += delta * GRAVITY
	else:
		if motion.y < MAX_FALL_SPEED.y:
			motion += delta * GRAVITY

	#move
	motion = move_and_slide(motion, UP)
	
	#play idle if we're not landing
	if anim != "land":
		new_anim = "idle"
	
	#play landing animation when hitting ground
	if is_on_floor() and anim == "fall":
		new_anim = "land"

	#jumping with buffer
	if is_on_floor() || wall_jumped:
		coyote_jump_buffer = 0
		if !has_jumped and jump_buffer < JUMP_BUFFER_MAX:
			jump_buffer = JUMP_BUFFER_MAX
			has_jumped = true
			motion.y = -JUMP_SPEED
			new_anim = "jump"
			wall_jumped = false
	jump_buffer+=1
		
	#jumping with coyote time
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0
		if !has_jumped and coyote_jump_buffer < JUMP_BUFFER_MAX:
			coyote_jump_buffer = JUMP_BUFFER_MAX
			has_jumped = true
			motion.y = -JUMP_SPEED
			new_anim = "jump"
			wall_jumped = false
	coyote_jump_buffer+=1

	#if we release the jump key while rising then cut off the jump
	if Input.is_action_just_released("jump"):
		has_jumped = false
		#if we're falling
		if motion.y < 0:
			motion.y = lerp(motion.y, 0, JUMP_FALLOFF_SPEED)
			new_anim = "midair"

	#play jump animations
	if !is_on_floor():
		if motion.y > -100 and motion.y < 100:
			new_anim = "midair"
		elif motion.y < 0 and motion.y > -JUMP_SPEED+100:
			new_anim = "jump"
		elif motion.y > 0:
			new_anim = "fall"
				
	if sticky_wall_buffer <= 0:
		#movement on ground
		if is_on_floor():
			if Input.is_action_pressed("move_right"):
				motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
#				if motion.x < ACCELERATION*4:
#					#new_anim = "run"
				#else:
				new_anim = "walk"
				facing_right = true
				friction = false
			elif Input.is_action_pressed("move_left"):
				motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
#				if motion.x > -ACCELERATION*4:
#					new_anim = "walk"
#				else:
				new_anim = "walk"
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
			
	#wall jump
	if on_wall:
		new_anim = "cling"
		facing_right = !facing_right
		if Input.is_action_just_pressed("jump"):
			motion.x = -haxis*MAX_SPEED
			wall_jumped = true

func _process(delta):
	#play animation
	if anim != new_anim:
		anim = new_anim
		$Sprite.play(anim)
	$Sprite.flip_h = !facing_right

func kill_player():
	global_position = current_checkpoint.global_position
	
func enemy_jump():
	motion.y = -JUMP_SPEED
	wall_jumped = true

func _on_WallOverlap_body_entered(body):
	if body is TileMap:
		kill_player()

func _on_WallOverlap_area_entered(area):
	if area.is_in_group("Checkpoint"):
		current_checkpoint = area
	
func _on_CollisionRight_body_entered(body):
	if body is TileMap:
		collision_right = true
		on_wall = true

func _on_CollisionRight_body_exited(body):
	if body is TileMap:
		collision_right = false
		on_wall = false

func _on_CollisionLeft_body_entered(body):
	if body is TileMap:
		collision_left = true
		on_wall = true

func _on_CollisionLeft_body_exited(body):
	if body is TileMap:
		collision_left = false
		on_wall = false
		
func got_key():
	key_count += 1

func _on_Sprite_animation_finished():
	if $Sprite.animation == "land":
		new_anim = "idle"
