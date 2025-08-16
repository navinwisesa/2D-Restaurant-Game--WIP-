extends Node2D

@export var money : int = 420


@onready var moneybox = $CurrentScene/Town/Player/MoneyBox/MoneyValue




var player_location = Vector2(0, 0)
var player_direction = Vector2(0, 0)
var next_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func transition_to_scene(new_scene: String, spawn_location, spawn_direction):
	next_scene = new_scene
	player_location = spawn_location
	player_direction = spawn_direction
	
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
# Called every frame. 'delta' is the elapsed time since the previous frame.

func finished_fading():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(next_scene).instantiate())
	
	var player =  $CurrentScene.get_children().back().get_node("Player")
	player.set_spawn(player_location, player_direction)
	
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")
	

	
