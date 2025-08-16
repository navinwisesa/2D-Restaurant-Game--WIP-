extends Control

var is_inv = false

@onready var inv_visuals = $InvBackground
@onready var bunlabel = $Inventory/InvBackground/BunInv/Bunvalue
@onready var hamlabel = $Inventory/InvBackground/HamInv/Hamvalue
@onready var cheeselabel = $Inventory/InvBackground/CheeseInv/Cheesevalue
@onready var lettucelabel = $Inventory/InvBackground/LettuceInv/Lettucevalue
@onready var tomatolabel = $Inventory/InvBackground/TomatoInv/Tomatovalue

@export var bun_amount : int = 10
@export var ham_amount : int = 5
@export var cheese_amount : int = 5
@export var lettuce_amount : int = 5
@export var tomato_amount : int = 5

signal update_bun_amount
signal update_ham_amount
signal update_cheese_amount
signal update_lettuce_amount
signal update_tomato_amount
# Called when the node enters the scene tree for the first time.
func _ready():
	update_bun_amount.emit(bun_amount)
	update_ham_amount.emit(ham_amount)
	update_cheese_amount.emit(cheese_amount)
	update_lettuce_amount.emit(lettuce_amount)
	update_tomato_amount.emit(tomato_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("inv") and is_inv == false:
		print("entering inv")
		inv_visuals.show()
		is_inv = true
		
	elif event.is_action_pressed("inv") and is_inv == true:
		print("exiting inv")
		inv_visuals.hide()
		is_inv = false






	
