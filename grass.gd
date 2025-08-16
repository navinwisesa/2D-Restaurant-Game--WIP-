extends Node2D

@onready var anim_player = $AnimationPlayer
var grass_overlay_texture = load("res://Assets/Grass/stepped_tall_grass.png")
var grass_overlay : TextureRect = null
var player_inside : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_inside:
		var player_pos = get_node("Player").position
		if not grass_overlay:
			grass_overlay = TextureRect.new()
			grass_overlay.texture = grass_overlay_texture
			add_child(grass_overlay)
		grass_overlay.position = player_pos - grass_overlay.texture.get_size() / 2
	else:
		if grass_overlay:
			grass_overlay.queue_free()
			grass_overlay = null
		print("stepped!")

	# Create grass_overlay only if it doesn't exist
