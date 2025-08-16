extends Area2D

signal enter_mall_door
signal in_mall_door
@export_file var next_scene_path : String
@export var spawn_location = Vector2(0, 0)
@export var spawn_direction = Vector2(0, 0)



var player_entered = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = find_parent("CurrentScene").get_children().back().get_node("Player")
	player.connect("enter_mall_door", self.open_mall_door)
	player.connect("in_mall_door", self.close_mall_door)

func open_mall_door():
	pass

func close_mall_door():
	if player_entered == false:
		door_mall_closed()

func door_mall_closed():
	if player_entered == false:
		get_node(NodePath("/root/SceneManager")).transition_to_scene(next_scene_path, spawn_location, spawn_direction)
		print(next_scene_path, " entered!")


func _process(delta):
	pass


func _on_body_entered(body):
	player_entered = true


func _on_body_exited(body):
	player_entered = false
