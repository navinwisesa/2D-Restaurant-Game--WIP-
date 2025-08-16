extends Area2D

signal store_interacted
signal store_exited 

@onready var label = $"../Label"
var in_interactionspace = false


func _on_body_entered(body):
	print("store entered")
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
	store_interacted.emit()
	var StoreMenu = get_node("Player")
	if StoreMenu:
		StoreMenu._on_store_interacted()

func sign_out():
	store_exited.emit()
