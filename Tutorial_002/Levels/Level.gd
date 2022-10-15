extends Node2D

const PlayerScene = preload("res://Characters/Player.tscn")

var player_spawn_location = Vector2.ZERO

onready var camera: = $Camera2D
onready var player: = $Player
onready var timer: = $Timer
onready var hud: = $HUD
export(int) var levelNumber

func _ready():
	VisualServer.set_default_clear_color(Color.lightblue)
	player.connect_camera(camera)
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
	player.connect_camera(camera)
	hud.update_hud_health(player.playerHealth)


func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position

func _update_hud_health(playerHealth):
	hud.update_hud_health(playerHealth)


