extends Area2D

export(String,FILE, "*.tscn") var target_level_path = ""

var player = false

func go_to_next_room():
	Transitions.play_exit_transition()
	get_tree().paused = true
	yield(Transitions,"transition_completed")
	get_tree().change_scene(target_level_path)
	get_tree().paused = false
	Transitions.play_enter_transition()
	
func _process(delta):
	if(not player):
		return
	if(not player.is_on_floor()):
		return
	if(Input.is_action_just_pressed("ui_up")):
		if(target_level_path.empty()):
			return
		else:
			go_to_next_room()

func _on_Door_body_entered(body):
	if(!(body is Player)): 
		return
	body.on_door= true
	player = body
	if(target_level_path.empty()):
		return

func _on_Door_body_exited(body):
	if(!(body is Player)): 
		return
	body.on_door = false
	player = null
