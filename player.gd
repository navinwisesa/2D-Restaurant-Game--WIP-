extends CharacterBody2D

@export var walk_speed = 5


@onready var global_data = preload("res://GlobalData.gd")

const TILE_SIZE = 16
var tilecount = 1

signal player_moving
signal player_stopped
signal enter_house_door
signal in_house_door
signal enter_resto_door
signal in_resto_door
signal enter_mall_door
signal in_mall_door
signal enter_mall_door_2
signal in_mall_door_2
signal enter_stair_1
signal in_stair_1
signal enter_stair_2
signal in_stair_2
signal in_kitchen_door
signal enter_kitchen_door

signal go_to_inventory
signal exit_inventory


signal bun_bought
signal ham_bought
signal cheese_bought
signal lettuce_bought
signal tomato_bought

signal update_money
signal update_bun_amount
signal update_ham_amount
signal update_cheese_amount
signal update_lettuce_amount
signal update_tomato_amount


@onready var player = $Sprite2D
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var ray = $CollisionRayCast2D
@onready var door_ray = $DoorRayCast2D
@onready var restodoor_ray = $RestoRayCast2D
@onready var malldoor_ray = $MallRayCast2D
@onready var malldoor_ray2 = $MallRayCast2D2
@onready var staircast_1 = $StairCast1
@onready var staircast_2 = $StairCast2
@onready var kitchencast = $KitchenCast2D

@onready var restosign = $TextureRect
@onready var housesign = $TextureRect2

@onready var securitybox = $SecurityBox
@onready var securitytext1 = $SecurityBox/Label2
@onready var securitytext2 = $SecurityBox/Label3
@onready var securitynextbox = $SecurityBox/TextureRect
@onready var exitsecurity = $SecurityBox/InstructionLabel2

@onready var bstatus = $BurgerStatus
@onready var inv = $Inventory
@onready var moneybox = $"../../../MoneyBox"
@onready var moneylabel = $"../../../MoneyBox/MoneyValue"

@onready var storemenu = $StoreMenu
@onready var confirmationbox = $StoreMenu/Label9
@onready var buncolor = $StoreMenu/ColorRect2
@onready var hamcolor = $StoreMenu/ColorRect3
@onready var cheesecolor = $StoreMenu/ColorRect4
@onready var lettucecolor = $StoreMenu/ColorRect5
@onready var tomatocolor = $StoreMenu/ColorRect6

@onready var bunvalue = $Inventory/BunInv
@onready var fhamvalue = $Inventory/FHamInv
@onready var chamvalue = $Inventory/CHamInv
@onready var cheesevalue = $Inventory/CheeseInv
@onready var tomatovalue = $Inventory/TomatoInv
@onready var lettucevalue = $Inventory/LettuceInv


var input_direction = Vector2(0, 1)
var is_moving = false
var stop_input : bool = false
enum PlayerState { IDLE, WALKING }
var percent_moved_to_next_tile = 0.0
var initial_position = Vector2.ZERO
var player_state = PlayerState.IDLE
var can_move = true
var security_activated = false
var in_store = false
var money = 420
var bun_amount = 0
var frozen_ham_amount = 0 
var cooked_ham_amount = 0
var cheese_amount = 0
var lettuce_amount = 0
var tomato_amount = 0

var buying_buns = false
var buying_ham = false
var buying_cheese = false
var buying_lettuce = false
var buying_tomato = false
var in_inv = false

func _ready():
	$Sprite2D.visible = true
	anim_tree.set("parameters/Idle/blend_position", input_direction)
	anim_tree.set("parameters/Walk/blend_position", input_direction)
	bunvalue.set_text(str(bun_amount))
	fhamvalue.set_text(str(frozen_ham_amount))
	chamvalue.set_text(str(cooked_ham_amount))
	cheesevalue.set_text(str(cheese_amount))
	lettucevalue.set_text(str(lettuce_amount))
	tomatovalue.set_text(str(tomato_amount))
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_spawn(location: Vector2, direction: Vector2):
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Walk/blend_position", direction)
	position = location
func _process(delta):
	if can_move == true:
		if is_moving == false:
			process_player_input()
		elif input_direction != Vector2.ZERO:
			anim_state.travel("Walk")
			move(delta)
		else:
			anim_state.travel("Idle")
			is_moving = false

func process_player_input():
	if can_move == true:
		if input_direction.y == 0:
			input_direction.x = int(Input.get_action_strength("right")) - int(Input.get_action_strength("left"))
		if input_direction.x == 0:
			input_direction.y = int(Input.get_action_strength("down")) - int(Input.get_action_strength("up"))
			
		if input_direction != Vector2.ZERO:
			anim_tree.set("parameters/Idle/blend_position", input_direction)
			anim_tree.set("parameters/Walk/blend_position", input_direction)
			initial_position = position
			is_moving = true
		else:
			anim_state.travel("Idle")
		

func inside_house_door():
	in_house_door.emit()

func inside_resto_door():
	in_resto_door.emit()

func inside_mall_door():
	in_mall_door.emit()

func inside_mall_door_2():
	in_mall_door_2.emit()

func inside_stair_1():
	in_stair_1.emit()

func inside_stair_2():
	in_stair_2.emit()
	
func move(delta):
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	ray.target_position = desired_step
	ray.force_raycast_update()
	
	door_ray.target_position = desired_step
	door_ray.force_raycast_update()
	restodoor_ray.target_position = desired_step
	restodoor_ray.force_raycast_update()
	malldoor_ray.target_position = desired_step
	malldoor_ray.force_raycast_update()
	malldoor_ray2.target_position = desired_step
	malldoor_ray2.force_raycast_update()
	staircast_1.target_position = desired_step
	staircast_1.force_raycast_update()
	staircast_2.target_position = desired_step
	staircast_2.force_raycast_update()
	kitchencast.target_position = desired_step
	kitchencast.force_raycast_update()

	
	if door_ray.is_colliding():
		print("house colliding")
		enter_house_door.emit()
		can_move = false
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		in_house_door.emit()
		$AnimationPlayer.play("gone")
		print("house entered!")
		percent_moved_to_next_tile += walk_speed * delta
		
		
	if restodoor_ray.is_colliding():
		print("resto colliding")
		enter_resto_door.emit()
		can_move = false
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		in_resto_door.emit()
		$AnimationPlayer.play("gone")
		print("resto entered!")
		percent_moved_to_next_tile += walk_speed * delta
		
		
	if malldoor_ray.is_colliding():
		print("mall colliding")
		enter_mall_door.emit()
		can_move = false
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		in_mall_door.emit()
		$AnimationPlayer.play("gone")
		print("mall entered!")
		percent_moved_to_next_tile += walk_speed * delta
		
		
	
	if malldoor_ray2.is_colliding():
		print("mall colliding")
		enter_mall_door_2.emit()
		can_move = false
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		in_mall_door_2.emit()
		$AnimationPlayer.play("gone")
		print("mall entered!")
		percent_moved_to_next_tile += walk_speed * delta
		
		
		
	if staircast_1.is_colliding():
		print("stair colliding")
		enter_stair_1.emit()
		can_move = false
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		in_stair_1.emit()
		$AnimationPlayer.play("gone")
		print("mall entered!")
		percent_moved_to_next_tile += walk_speed * delta
		
		
	
	if staircast_2.is_colliding():
		print("stair colliding")
		enter_stair_2.emit()
		can_move = false
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		in_stair_2.emit()
		$AnimationPlayer.play("gone")
		print("mall entered!")
		percent_moved_to_next_tile += walk_speed * delta
		

	
	if kitchencast.is_colliding():
		print("resto colliding")
		enter_kitchen_door.emit()
		can_move = false
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		in_kitchen_door.emit()
		$AnimationPlayer.play("gone")
		print("kitchen entered!")
		percent_moved_to_next_tile += walk_speed * delta
	

		
		
		
	if !ray.is_colliding():
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile == 1.0:
			player_moving.emit()
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			player_stopped.emit()
		else:
			position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)
	else:
		is_moving = false




func _on_interaction_space_2_sign_house_interacted():
	housesign.show()


func _on_interaction_space_2_sign_house_exited():
	housesign.hide()




func _on_interaction_space_sign_resto_interacted():
	restosign.show()


func _on_interaction_space_sign_resto_exited():
	restosign.hide()




func _on_security_security_interacted():
	securitybox.show()
	security_activated = true
	

func _input(event):
	if event.is_action_pressed("next") and security_activated == true:
		securitytext1.hide()
		securitynextbox.hide()
		securitytext2.show()
		exitsecurity.show()
	
	if event.is_action_pressed("option1") and in_store == true:
		print("buns")
		confirmationbox.set_text("Would you like to buy a bun?")
		buncolor.color = Color(255, 0, 0)
		hamcolor.color = Color(76, 255, 255)
		cheesecolor.color = Color(76, 255, 255)
		lettucecolor.color = Color(76, 255, 255)
		tomatocolor.color = Color(76, 255, 255)
		buying_buns = true
		buying_ham = false
		buying_cheese = false
		buying_lettuce = false
		buying_tomato = false
		
		
	if event.is_action_pressed("option2") and in_store == true:
		print("ham")
		confirmationbox.set_text("Would you like to buy ham?")
		buncolor.color = Color(76, 255, 255)
		hamcolor.color = Color(255, 0, 0)
		cheesecolor.color = Color(76, 255, 255)
		lettucecolor.color = Color(76, 255, 255)
		tomatocolor.color = Color(76, 255, 255)
		buying_buns = false
		buying_ham = true
		buying_cheese = false
		buying_lettuce = false
		buying_tomato = false
		
	if event.is_action_pressed("option3") and in_store == true:
		print("cheese")
		confirmationbox.set_text("Would you like to buy cheese?")
		buncolor.color = Color(76, 255, 255)
		hamcolor.color = Color(76, 255, 255)
		cheesecolor.color = Color(255, 0, 0)
		lettucecolor.color = Color(76, 255, 255)
		tomatocolor.color = Color(76, 255, 255)
		buying_buns = false
		buying_ham = false
		buying_cheese = true
		buying_lettuce = false
		buying_tomato = false
		
	if event.is_action_pressed("option4") and in_store == true:
		print("lettuce")
		confirmationbox.set_text("Would you like to buy lettuce?")
		buncolor.color = Color(76, 255, 255)
		hamcolor.color = Color(76, 255, 255)
		cheesecolor.color = Color(76, 255, 255)
		lettucecolor.color = Color(255, 0, 0)
		tomatocolor.color = Color(76, 255, 255)
		buying_buns = false
		buying_ham = false
		buying_cheese = false
		buying_lettuce = true
		buying_tomato = false
		
	if event.is_action_pressed("option5") and in_store == true:
		print("tomato")
		confirmationbox.set_text("Would you like to buy tomato?")
		buncolor.color = Color(76, 255, 255)
		hamcolor.color = Color(76, 255, 255)
		cheesecolor.color = Color(76, 255, 255)
		lettucecolor.color = Color(76, 255, 255)
		tomatocolor.color = Color(255, 0, 0)
		buying_buns = false
		buying_ham = false
		buying_cheese = false
		buying_lettuce = false
		buying_tomato = true
	
	if event.is_action_pressed("yes") and buying_buns == true:
		bun_bought.emit()
	elif event.is_action_pressed("yes") and buying_ham == true:
		ham_bought.emit()
	elif event.is_action_pressed("yes") and buying_cheese == true:
		print("cheese bought!")
		money -= 5
		cheese_amount += 1
		update_money.emit(money)
		update_cheese_amount.emit(cheese_amount)
	elif event.is_action_pressed("yes") and buying_lettuce == true:
		print("lettuce bought!")
		money -= 5
		lettuce_amount += 1
		
		update_money.emit(money)
		update_lettuce_amount.emit(lettuce_amount)
	elif event.is_action_pressed("yes") and buying_tomato == true:
		print("tomato bought!")
		money -= 5
		tomato_amount += 1
		
		update_money.emit(money)
		update_tomato_amount.emit(tomato_amount)
	
	
	if event.is_action_pressed("inv"):
		go_to_inventory.emit()
	elif event.is_action_released("inv"):
		exit_inventory.emit()
		



func _on_security_security_exited():
	securitybox.hide()
	securitytext1.show()
	securitynextbox.show()
	securitytext2.hide()
	exitsecurity.hide()
	security_activated = false




func _on_store_space_store_exited():
	can_move = true
	in_store = false
	storemenu.hide()
	player.show()
	


func _on_store_space_store_interacted():
	can_move = false
	in_store = true
	storemenu.show()
	player.hide()



func _on_update_money(money):
	pass
	




func _on_go_to_inventory():
	inv.show()
	bstatus.show()
	in_inv = true
	

func _on_exit_inventory():
	inv.hide()
	bstatus.hide()
	in_inv = false


func _on_fridge_storage_fridgestorage_interacted():
	can_move = false
	print("Interacted w/ fridge!")


func _on_fridge_storage_fridgestorage_exited():
	can_move = true
	print("Exited the fridge!")


func _on_fridge_storage_fridge_contents_enter():
	can_move = false
	print("Entered fridge!")


func _on_fridge_storage_fridge_contents_exit():
	can_move = true
	print("Exited fridge!")

func _on_fridge_storage_collect_bun(amount_collected_from_fridge):
	bun_amount += amount_collected_from_fridge
	bunvalue.set_text(str(bun_amount))
	
func _on_fridge_storage_collect_ham(amount_collected_from_fridge):
	frozen_ham_amount += amount_collected_from_fridge
	fhamvalue.set_text(str(frozen_ham_amount))


func _on_fridge_storage_collect_cheese(amount_collected_from_fridge):
	cheese_amount += amount_collected_from_fridge
	cheesevalue.set_text(str(cheese_amount))


func _on_fridge_storage_collect_tomato(amount_collected_from_fridge):
	tomato_amount += amount_collected_from_fridge
	tomatovalue.set_text(str(tomato_amount))


func _on_fridge_storage_collect_lettuce(amount_collected_from_fridge):
	lettuce_amount += amount_collected_from_fridge
	lettucevalue.set_text(str(lettuce_amount))
