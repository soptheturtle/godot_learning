extends Node2D

const PlayerScene = preload("res://Characters/Player.tscn")

var player_spawn_location = Vector2.ZERO

onready var camera: = $Camera2D
onready var cameraTL: = $Camera2D/CameraTopLeft
onready var cameraBR: = $Camera2D/CameraBottomRight
onready var player: = $Player
onready var timer: = $Timer
onready var hud: = $HUD
onready var background: = $Background
export(int) var levelNumber

func _ready():
	VisualServer.set_default_clear_color(Color.lightblue)
	player.connect_camera(camera,cameraTL,cameraBR)
	player_spawn_location = player.global_position
	Events.connect("player_died",self,"_on_player_died")
	Events.connect("hit_checkpoint",self,"_on_hit_checkpoint")
	Events.connect("player_hurt",self,"_update_hud_health")
	hud.update_message_text(levelNumber)
	


func _on_player_died(playerHealth):
	hud.update_hud_health(playerHealth)
	timer.start(1.0)
	yield(timer,"timeout")
	var player = PlayerScene.instance()
	player.position = player_spawn_location
	add_child(player)
	player = $Player
	player.connect_camera(camera,cameraTL,cameraBR)
	hud.update_hud_health(player.playerHealth)

func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position

func _update_hud_health(playerHealth):
	hud.update_hud_health(playerHealth)

func _process(delta):
	#Check Left Most Position
	if(camera.position.x < cameraTL.position.x):
		camera.position.x = cameraTL.position.x
	#Check Right Most Position
	if(camera.position.x > cameraBR.position.x):
		camera.position.x = cameraBR.position.x
	#Check Top Most Position
	if(camera.position.y < cameraTL.position.y):
		camera.position.y = cameraTL.position.y
	#Check Bottom Most Position
	if(camera.position.y > cameraBR.position.y):
		camera.position.y = cameraBR.position.y
	
