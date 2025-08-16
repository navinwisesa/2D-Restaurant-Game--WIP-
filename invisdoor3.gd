extends Area2D

signal enter_stair_up_1
signal in_stair_up_1
@export_file var next_scene_path : String
@export var spawn_location = Vector2(0, 0)
@export var spawn_direction = Vector2(0, 0)



var player_entered = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var player = find_parent("CurrentScene").get_children().back().get_node("Player")
	player.connect("enter_stair_1", self.open_stair1)
	player.connect("in_stair_1", self.close_stair1)

func open_stair1():
	pass

func close_stair1():
	if player_entered == false:
		stair_hit()

func stair_hit():
	if player_entered == false:
		get_node(NodePath("/root/SceneManager")).transition_to_scene(next_scene_path, spawn_location, spawn_direction)
		print(next_scene_path, " entered!")


func _process(delta):
	pass


func _on_body_entered(body):
	player_entered = true


func _on_body_exited(body):
	player_entered = false
