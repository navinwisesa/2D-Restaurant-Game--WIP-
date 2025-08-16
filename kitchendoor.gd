extends Area2D

signal enter_kitchen_door
signal in_kitchen_door
@export_file var next_scene_path : String

@export var spawn_location = Vector2(0, 0)
@export var spawn_direction = Vector2(0, 0)

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

var player_entered = false
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.visible = false
	var player = find_parent("CurrentScene").get_children().back().get_node("Player")
	player.connect("enter_kitchen_door", self.open_kitchen_door)
	player.connect("in_kitchen_door", self.close_kitchen_door)

func open_kitchen_door():
	if player_entered == false:
		anim_player.play("OpenKitchenDoor")

func close_kitchen_door():
	if player_entered == false:
		anim_player.play("CloseKitchenDoor")
		door_kitchen_closed()

func door_kitchen_closed():
	if player_entered == false:
		get_node(NodePath("/root/SceneManager")).transition_to_scene(next_scene_path, spawn_location, spawn_direction)
		print(next_scene_path, " entered!")

func _process(delta):
	pass


func _on_body_entered(body):
	player_entered = true


func _on_body_exited(body):
	player_entered = false
