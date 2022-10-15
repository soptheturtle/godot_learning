extends Area2D

onready var animatedSprite: = $AnimatedSprite

var active = true

func _on_Checkpoint_body_entered(body):
	if(!(body is Player)):
		return
	if(!active):
		return
	active = false
	animatedSprite.play("Checked")
	Events.emit_signal("hit_checkpoint",position)
	
