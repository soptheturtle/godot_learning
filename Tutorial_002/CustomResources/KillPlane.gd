extends Area2D


func _on_KillPlane_body_entered(body):
	if(body is Player):
		body.player_hurt(1,600)
