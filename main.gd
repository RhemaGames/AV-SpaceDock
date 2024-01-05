extends Node

signal changed_ship_type(type)
@export_enum("Striker","Midfield","Defender") var ship_type:String = "Striker":
	set(new_type):
		ship_type = new_type
		emit_signal("changed_ship_type",ship_type)

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
	

