extends Control


## Ship select variables. 
@onready var ShipSelectBack = $ShipSelect/HBoxContainer/Prev
@onready var ShipSelectNext = $ShipSelect/HBoxContainer/Next
@onready var ShipLabel = $ShipSelect/HBoxContainer/Label

@onready var ShipClassStrikers = $topbar/HBoxContainer/Button
@onready var ShipClassMidfields = $topbar/HBoxContainer/Button2
@onready var ShipClassDefenders = $topbar/HBoxContainer/Button3

@onready var Options = $topbar/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_av_button_focused(obj,is_focused):
	for c in $topbar/HBoxContainer.get_children():
		if !c is TextureRect:
			if obj.name != c.get_child(0).name:
				c.get_child(0).focus = false
