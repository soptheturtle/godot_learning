
extends Path2D

enum ANIMATION_TYPE {LOOP, BOUNCE}
export(int) var speed setget set_speed

export(ANIMATION_TYPE) var animation_type setget set_animation_type
onready var animationPlayer: = $AnimationPlayer

func set_animation_type(value):
	animation_type = value
	var ap = find_node("AnimationPlayer")
	if(ap):
		play_updated_animation(ap)

# Called when the node enters the scene tree for the first time.
func _ready():
	play_updated_animation(animationPlayer)

func set_speed(value):
	speed = value
	var ap = find_node("AnimationPlayer")
	if(ap):
		ap.playback_speed = speed

func play_updated_animation(ap):
	match animation_type:
		ANIMATION_TYPE.LOOP: ap.play("MoveAlongPathLoop")
		ANIMATION_TYPE.BOUNCE: ap.play("MoveAlongPathBounce")
