extends Area2D

signal fridgestorage_interacted
signal fridgestorage_exited 

signal fridge_contents_enter
signal fridge_contents_exit

signal collect_bun
signal collect_ham
signal collect_cheese
signal collect_tomato
signal collect_lettuce


@onready var label = $"../Interact space"
@onready var contentshow = $"../FridgeContents"

@onready var bun_text = $"../FridgeContents/BunFridge"
@onready var frozenham_text = $"../FridgeContents/HamFridge"
@onready var cheese_text = $"../FridgeContents/CheeseFridge"
@onready var tomato_text = $"../FridgeContents/TomatoFridge"
@onready var lettuce_text = $"../FridgeContents/LettuceFridge"
@onready var collect_indicator = $"../FridgeContents/AmountToCollect"

#pointers
@onready var bun_pointer = $"../FridgeContents/FBunPointer"
@onready var frozenham_pointer = $"../FridgeContents/FHamPointer"
@onready var cheese_pointer = $"../FridgeContents/FCheesePointer"
@onready var tomato_pointer = $"../FridgeContents/FTomatoPointer"
@onready var lettuce_pointer = $"../FridgeContents/FLettucePointer"

#amount ui system
@onready var amountlabel = $"../FridgeContents/LettuceFridgeText2"
@onready var amountlabel1 = $"../FridgeContents/TextureRect"
@onready var amountlabel2 = $"../FridgeContents/LettuceFridgeText3"
@onready var amountlabel3 = $"../FridgeContents/LettuceFridgeText4"
@onready var amountlabel4 = $"../FridgeContents/LettuceFridgeText5"

@onready var collectlimiter = $"../FridgeContents/LettuceFridgeText6" 

@export var bun_amount = 10
@export var frozenham_amount = 5
@export var cheese_amount = 5
@export var tomato_amount = 5
@export var lettuce_amount = 5

@export var amount_collected_from_fridge : int = 0

var in_interactionspace = false
var second_phase = true
var inside_fridge = false

var bun_menu = false
var frozen_ham_menu = false
var cheese_menu = false
var tomato_menu = false
var lettuce_menu = false

func _ready():
	bun_text.set_text(str(bun_amount))
	frozenham_text.set_text(str(frozenham_amount))
	cheese_text.set_text(str(cheese_amount))
	tomato_text.set_text(str(tomato_amount))
	lettuce_text.set_text(str(lettuce_amount))
	collect_indicator.set_text(str(amount_collected_from_fridge))
	
	bun_pointer.hide()
	frozenham_pointer.hide()
	cheese_pointer.hide()
	tomato_pointer.hide()
	lettuce_pointer.hide()
	
	amountlabel.hide()
	amountlabel1.hide()
	amountlabel2.hide()
	amountlabel3.hide()
	amountlabel4.hide()
	collect_indicator.hide()

func _input(event):
	if in_interactionspace and event.is_action_pressed("act"):
		sign_interaction()
	if event.is_action_pressed("exit"):
		sign_out()
	
	if event.is_action_pressed("option1") and inside_fridge == true:
		extract_bun()
		bun_menu = true
		frozen_ham_menu = false
		cheese_menu = false
		tomato_menu = false
		lettuce_menu = false
	elif event.is_action_pressed("option2") and inside_fridge == true:
		extract_frozen_ham()
		bun_menu = false
		frozen_ham_menu = true
		cheese_menu = false
		tomato_menu = false
		lettuce_menu = false
	elif event.is_action_pressed("option3") and inside_fridge == true:
		extract_cheese()
		bun_menu = false
		frozen_ham_menu = false
		cheese_menu = true
		tomato_menu = false
		lettuce_menu = false
	elif event.is_action_pressed("option4") and inside_fridge == true:
		extract_tomato()
		bun_menu = false
		frozen_ham_menu = false
		cheese_menu = false
		tomato_menu = true
		lettuce_menu = false
	elif event.is_action_pressed("option5") and inside_fridge == true:
		extract_lettuce()
		bun_menu = false
		frozen_ham_menu = false
		cheese_menu = false
		tomato_menu = false
		lettuce_menu = true
	
	if event.is_action_pressed("add"):
		print("added")
		amount_collected_from_fridge += 1
		collect_indicator.set_text(str(amount_collected_from_fridge))
	elif event.is_action_pressed("subtract"):
		print("subtracted")
		if amount_collected_from_fridge > 0:
			amount_collected_from_fridge -= 1
			collect_indicator.set_text(str(amount_collected_from_fridge))
			
	if event.is_action_pressed("yes") and bun_menu == true:
		if amount_collected_from_fridge <= bun_amount:
			bun_amount = bun_amount - amount_collected_from_fridge
			bun_text.set_text(str(bun_amount))
			collectlimiter.hide()
			collect_bun.emit(amount_collected_from_fridge)
			var Player = get_node("Player")
			if Player:
				Player.on_collect_bun(amount_collected_from_fridge)
		elif amount_collected_from_fridge > frozenham_amount:
			collectlimiter.show()
	elif event.is_action_pressed("yes") and frozen_ham_menu == true:
		if amount_collected_from_fridge <= frozenham_amount:
			frozenham_amount = frozenham_amount - amount_collected_from_fridge
			frozenham_text.set_text(str(frozenham_amount))
			collectlimiter.hide()
			collect_ham.emit(amount_collected_from_fridge)
			var Player = get_node("Player")
			if Player:
				Player.on_collect_ham(amount_collected_from_fridge)
		elif amount_collected_from_fridge > frozenham_amount:
			collectlimiter.show()
	elif event.is_action_pressed("yes") and cheese_menu == true:
		if amount_collected_from_fridge <= cheese_amount:
			cheese_amount = cheese_amount - amount_collected_from_fridge
			cheese_text.set_text(str(cheese_amount))
			collectlimiter.hide()
			collect_cheese.emit(amount_collected_from_fridge)
			var Player = get_node("Player")
			if Player:
				Player.on_collect_cheese(amount_collected_from_fridge)
		elif amount_collected_from_fridge > cheese_amount:
			collectlimiter.show()
	elif event.is_action_pressed("yes") and tomato_menu == true:
		if amount_collected_from_fridge <= tomato_amount:
			tomato_amount = tomato_amount - amount_collected_from_fridge
			tomato_text.set_text(str(tomato_amount))
			collectlimiter.hide()
			collect_tomato.emit(amount_collected_from_fridge)
			var Player = get_node("Player")
			if Player:
				Player.on_collect_tomato(amount_collected_from_fridge)
		elif amount_collected_from_fridge > tomato_amount:
			collectlimiter.show()
	elif event.is_action_pressed("yes") and lettuce_menu == true:
		if amount_collected_from_fridge <= lettuce_amount:
			lettuce_amount = lettuce_amount - amount_collected_from_fridge
			lettuce_text.set_text(str(lettuce_amount))
			collectlimiter.hide()
			collect_lettuce.emit(amount_collected_from_fridge)
			var Player = get_node("Player")
			if Player:
				Player.on_collect_lettuce(amount_collected_from_fridge)
		elif amount_collected_from_fridge > lettuce_amount:
			collectlimiter.show()
			
			
	
func _on_body_entered(body):
	print("fridge space entered")
	in_interactionspace = true
	if in_interactionspace:
		print(in_interactionspace)
		label.show()

func _on_body_exited(body):
	in_interactionspace = false
	if !in_interactionspace:
		print(in_interactionspace)
		label.hide()
		
		
func sign_interaction():
	inside_fridge = true
	contentshow.show()
	print("show content")
	fridge_contents_enter.emit()
	label.hide()
	var Player = get_node("Player")
	if Player:
		Player._on_fridge_contents_enter()

func sign_out():
	inside_fridge = false
	contentshow.hide()
	fridge_contents_exit.emit()
	var Player = get_node("Player")
	if Player:
		Player._on_fridge_contents_exit()
func extract_bun():
	bun_pointer.show()
	frozenham_pointer.hide()
	cheese_pointer.hide()
	tomato_pointer.hide()
	lettuce_pointer.hide()
	amountlabel.show()
	amountlabel1.show()
	amountlabel2.show()
	amountlabel3.show()
	amountlabel4.show()
	collect_indicator.show()
	
func extract_frozen_ham():
	bun_pointer.hide()
	frozenham_pointer.show()
	cheese_pointer.hide()
	tomato_pointer.hide()
	lettuce_pointer.hide()
	amountlabel.show()
	amountlabel1.show()
	amountlabel2.show()
	amountlabel3.show()
	amountlabel4.show()
	collect_indicator.show()


func extract_cheese():
	bun_pointer.hide()
	frozenham_pointer.hide()
	cheese_pointer.show()
	tomato_pointer.hide()
	lettuce_pointer.hide()
	amountlabel.show()
	amountlabel1.show()
	amountlabel2.show()
	amountlabel3.show()
	amountlabel4.show()
	collect_indicator.show()

func extract_tomato():
	bun_pointer.hide()
	frozenham_pointer.hide()
	cheese_pointer.hide()
	tomato_pointer.show()
	lettuce_pointer.hide()
	amountlabel.show()
	amountlabel1.show()
	amountlabel2.show()
	amountlabel3.show()
	amountlabel4.show()
	collect_indicator.show()

func extract_lettuce():
	bun_pointer.hide()
	frozenham_pointer.hide()
	cheese_pointer.hide()
	tomato_pointer.hide()
	lettuce_pointer.show()
	amountlabel.show()
	amountlabel1.show()
	amountlabel2.show()
	amountlabel3.show()
	amountlabel4.show()
	collect_indicator.show()
	
