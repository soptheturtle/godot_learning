extends CanvasLayer

export(String,FILE, "*.tscn") var first_level = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.darkblue)


func _on_StartGameButton_pressed():
	get_tree().change_scene(first_level)


func _on_QuitGameButton_pressed():
	get_tree().quit()



