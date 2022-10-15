extends Area2D
signal hit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 400
var screen_size
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO #The player's Movement Vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta #Update Position
	position.x = clamp(position.x, 0, screen_size.x) #Don't let the player leave the screen on X axis
	position.y = clamp(position.y, 0, screen_size.y) #Don't let the player leave the screen on Y axis
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		#You can pass boolean arguments as assignments in Godot
		$AnimatedSprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	



func _on_Player_body_entered(_body):
	hide() #Player disappears after being hit
	emit_signal("hit")
	#Must be deferred as we can't change physics properties on a physics callback
	$CollisionShape2D.set_deferred("disabled",true)

#Reset player starting position
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false





