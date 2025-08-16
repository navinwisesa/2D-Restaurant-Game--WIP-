extends Area2D

signal sign_house_interacted
signal sign_house_exited 

@onready var label = $"../Label2"
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
	sign_house_interacted.emit()
	var TextBox = get_node("Player")
	if TextBox:
		TextBox._on_sign_house_interacted()

func sign_out():
	sign_house_exited.emit()
