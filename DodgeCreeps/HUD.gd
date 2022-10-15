extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	#Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	
	
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	
	#Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1),"timeout")
	$StartButton.show()
	$ScoreLabel.text = str(0)

func update_score(score):
	$ScoreLabel.text = str(score)



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MessageTimer_timeout():
	#I had to put this here but really it makes more
	#sense to me to have the message be timed out without a timer. Otherwise
	#this function will run every time to the timer ends
	var _one = 1
	#$Message.hide()




func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
