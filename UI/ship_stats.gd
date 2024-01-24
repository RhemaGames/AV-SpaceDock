extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ship_changed(ship):
	$VBoxContainer/Name.text = ship["stats"]["Name"]
	$VBoxContainer/Class.text = ship["class"]
	
	for s in [$VBoxContainer/Hull,$VBoxContainer/Speed,$VBoxContainer/Accel,$VBoxContainer/Turn]:
		s.stat_max = Mistro.ship_class_base_stats[ship["class"]][s.name] * 2.0
		s.stat_current = ship["stats"][s.name]
		s.stat_default = Mistro.ship_class_base_stats[ship["class"]][s.name]


func _on_visibility_changed():
	if visible:
		if !Mistro.main.is_connected("changed_ship",Callable(self,"_on_ship_changed")):
			Mistro.main.connect("changed_ship",Callable(self,"_on_ship_changed"))


func _on_ui_visibility_changed():
	visible = get_parent().visible
