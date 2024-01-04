extends PanelContainer

signal has_focus(obj)
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/BaseControl/Base.focus = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_av_button_focused(obj,is_focused):
	for c in $VBoxContainer/HBoxContainer.get_children():
		if obj.name != c.get_child(0).name:
			c.get_child(0).focus = false
	
	pass # Replace with function body.
