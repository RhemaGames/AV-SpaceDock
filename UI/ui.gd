extends Control


## Ship select variables. 
@onready var ShipSelectBack = $ShipSelect/HBoxContainer/Prev
@onready var ShipSelectNext = $ShipSelect/HBoxContainer/Next
@onready var ShipLabel = $ShipSelect/HBoxContainer/Label

@onready var ShipClassStrikers = $topbar/HBoxContainer/StrikerControl/Striker
@onready var ShipClassMidfields = $topbar/HBoxContainer/MidfieldControl/Midfield
@onready var ShipClassDefenders = $topbar/HBoxContainer/DefenderControl/Defender

@onready var Options = $topbar/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_av_button_focused(obj,is_focused):
	var ship_type = obj.name
	Mistro.main.ship_type = ship_type
	for c in $topbar/HBoxContainer.get_children():
		if !c is TextureRect:
			if obj.name != c.get_child(0).name:
				c.get_child(0).focus = false

func _on_topbar_button_pressed(button):
	print(button.name)
	


func _on_prev_focused(obj_name, is_focused):
	Mistro.main.get_node("Dock").current_ship_index -= 1
	pass # Replace with function body.


func _on_next_focused(obj_name, is_focused):
	Mistro.main.get_node("Dock").current_ship_index += 1
	pass # Replace with function body.


func _on_visibility_changed():
	if visible:
		Mistro.main.connect("changed_ship_type",Callable(self,"_on_ship_type_changed"))

func _on_ship_type_changed(type):
	for c in $topbar/HBoxContainer.get_children():
		if !c is TextureRect:
			if type == c.get_child(0).name:
				c.get_child(0).focus = true


func _on_ship_parts_start_build():
	var tween = get_tree().create_tween()
	var end_location = $ShipParts.position.x-$ShipParts.size.x
	tween.tween_property($ShipParts,"position",Vector2(end_location,$ShipParts.position.y),0.4)
	pass


func _on_ship_parts_end_build():
	var tween = get_tree().create_tween()
	var end_location = $ShipParts.position.x+$ShipParts.size.x
	tween.tween_property($ShipParts,"position",Vector2(end_location,$ShipParts.position.y),0.4)
	pass
