extends Node

signal changed_ship_type(type)
signal changed_ship(ship)

signal changed_ship_opt(type,data)

@export_enum("Striker","Midfield","Defender") var ship_type:String = "Striker":
	set(new_type):
		ship_type = new_type
		emit_signal("changed_ship_type",ship_type)
		
var current_ship:Dictionary:
	set(new_ship):
		current_ship = new_ship
		emit_signal("changed_ship",current_ship)

# Called when the node enters the scene tree for the first time.
func _ready():
	Mistro.main = self
	if Mistro.create_big_list("scenes/Ships"):
		Mistro.load_ships()
	$UI.show()
	$Dock.show()
	emit_signal("changed_ship_type",ship_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_changed_ship_type(type):
	print("Main Sees change to. ",type)
	

