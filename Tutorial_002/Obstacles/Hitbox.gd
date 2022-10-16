extends Area2D

export(int) var damageAmount = 1


func _on_Hitbox_body_entered(body):
	if(body is Player):
		body.player_hurt(0,damageAmount)
