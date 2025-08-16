extends TextureRect

@onready var textbox = $"."
signal sign_house_interacted
signal sign_house_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	textbox.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_interaction_space_2_sign_house_interacted():
	textbox.show()


func _on_interaction_space_2_sign_house_exited():
	textbox.hide()
