extends Area2D

signal counterstorage_interacted
signal counterstorage_exited

signal counter_contents_enter
signal counter_contents_exit

signal collect_buns

@onready var bun_text = $"../FridgeContents/BunCounter"
@onready var cheese_text = $"../FridgeContents/CheeseCounter"
@onready var tomato_text = $"../FridgeContents/TomatoCounter"
@onready var lettuce_text = $"../FridgeContents/LettuceCounter"
@onready var



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
