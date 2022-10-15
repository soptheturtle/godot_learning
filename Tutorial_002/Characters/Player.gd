extends KinematicBody2D
class_name Player

enum { MOVE, CLIMB }

export(Resource) var moveData = preload("res://CustomResources/DefaultPlayerMovementData.tres") as PlayerMovementData
export(int) var playerHealth = 6


var velocity = Vector2.ZERO
var state = MOVE
var double_jump = 1
var buffered_jump = false
var coyote_jump = false
var on_door = false
var entered_kill_plane = false

onready var animatedSprite: = $AnimatedSprite
onready var ladderCheck: = $LadderCheck
onready var jumpBufferTimer: = $JumpBufferTimer
onready var coyoteJumpTimer: = $CoyoteJumpTimer
onready var remoteTransform2D: = $RemoteTransform2D

func _ready():
	animatedSprite.frames = load("res://Characters/PlayerGreenSkin.tres")

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left","ui_right")
	input.y = Input.get_axis("ui_up","ui_down")
	
	match state:
		MOVE: move_state(input,delta)
		CLIMB: climb_state(input,delta)

func move_state(input,delta):
	if(is_on_ladder() && Input.is_action_just_pressed("ui_up")):
		state = CLIMB
	
	apply_gravity(delta)
	
	if(!horizontal_move(input)):
		apply_friction(delta)
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x,delta)
		animatedSprite.animation = "Run"
		animatedSprite.flip_h = input.x > 0

	if is_on_floor():
		reset_double_jump()
	else:
		animatedSprite.animation = "Jump"

	if(can_jump()):
		input_jump()
	else:
		input_jump_release()
		input_double_jump()
		buffer_jump()
		fast_fall(delta)

	var was_in_air = !is_on_floor()
	var was_on_floor = is_on_floor()
	
	velocity = move_and_slide(velocity,Vector2.UP)
	
	var just_landed = is_on_floor() && was_in_air
	if(just_landed):
		animatedSprite.animation = "Run"
		animatedSprite.frame = 1
	
	var just_left_ground = !is_on_floor() && was_on_floor
	if(just_left_ground && velocity.y >= 0):
		coyote_jump = true
		coyoteJumpTimer.start()
	
func climb_state(input,delta):
	if(!is_on_ladder()):
		state = MOVE
	if(input.length() != 0):
		animatedSprite.animation = "Run"
	else:
		animatedSprite.animation = "Idle"
	velocity = input * moveData.climbSpeed
	velocity = move_and_slide(velocity,Vector2.UP)

func player_hurt(killPlaneEntry=0):
	playerHealth -= 1
	if(killPlaneEntry == 1):
		entered_kill_plane = true
		playerHealth = 0
	SoundPlayer.play_sound(SoundPlayer.HURT)
	if(playerHealth <= 0 || entered_kill_plane == true):
		queue_free()
		Events.emit_signal("player_died",playerHealth)
	else:
		Events.emit_signal("player_hurt",playerHealth)


func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path

func input_jump_release():
	if(Input.is_action_just_released("ui_up") && velocity.y < -moveData.min_jump_speed):
		velocity.y = -moveData.min_jump_speed

func input_double_jump():
	if(Input.is_action_just_pressed("ui_up") && double_jump > 0):
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = -moveData.jump_speed
		double_jump -= 1

func buffer_jump():
	if(Input.is_action_just_pressed("ui_up")):
		buffered_jump = true
		jumpBufferTimer.start()

func fast_fall(delta):
	if(velocity.y  > 0):
		velocity.y += moveData.fast_fell_speed * delta

func horizontal_move(input):
	return input.x != 0

func can_jump():
	return is_on_floor() || coyote_jump

func reset_double_jump():
	double_jump = moveData.doubleJumpCount

func input_jump():
	if(on_door):
		return
	if(Input.is_action_just_pressed("ui_up") || buffered_jump == true):
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = -moveData.jump_speed
		buffered_jump = false

func is_on_ladder():
	if(!ladderCheck.is_colliding()):
		return false
	var collider = ladderCheck.get_collider()
	if(!(collider is Ladder)):
		return false
	
	return true

func apply_gravity(delta):
	velocity.y += moveData.player_gravity * delta
	velocity.y = min(velocity.y, moveData.terminal_velocity)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x,0,moveData.player_friction * delta)

func apply_acceleration(amount,delta):
	velocity.x = move_toward(velocity.x, moveData.move_speed * amount,moveData.player_acceleration * delta)
	pass

func _on_JumpBufferTimer_timeout():
	buffered_jump = false

func _on_CoyoteJumpTimer_timeout():
	coyote_jump = false
