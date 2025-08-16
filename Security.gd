extends Area2D

signal security_interacted
signal security_exited 

@onready var label = $"../Label"
var in_interactionspace = false
var second_phase = true


func _on_body_entered(body):
	print("security entered")
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
	if event.is_action_pressed("next"):
		second_phase = true
	if event.is_action_pressed("exit") and second_phase == true:
		sign_out()
		
func sign_interaction():
	security_interacted.emit()
	var SecurityBox = get_node("Player")
	if SecurityBox:
		SecurityBox._on_security_interacted()

func sign_out():
	security_exited.emit()
