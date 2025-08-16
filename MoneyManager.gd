extends TextureRect

signal update_money
@onready var moneylabel = $MoneyValue
@export var money : int = 420
# Called when the node enters the scene tree for the first time.
func _ready():
	update_money.emit(money)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_update_money():
	moneylabel.set_text(str(money))
