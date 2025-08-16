extends Area2D

signal sign_resto_interacted
signal sign_resto_exited 

@onready var label = $"../Label"
var in_interactionspace = false

func _on_body_entered(body):
	in_interactionspace = true
	if in_interactionspace:
		print(in_interactionspace)
		label.show()

func _on_body_exited(body):
	in_interactionspace = false
	if !in_interactionspace:
		print(in_interactionspace)
		label.hide()
		

func _input(event):
	if in_interactionspace and event.is_action_pressed("act"):
		sign_interaction()
	if event.is_action_pressed("exit") or in_interactionspace == false:
		sign_out()
		
func sign_interaction():
	sign_resto_interacted.emit()
	var TextBox = get_node("/root/Town/Player/TextureRect")
	if TextBox:
		TextBox._on_sign_interacted()

func sign_out():
	sign_resto_exited.emit()




		
