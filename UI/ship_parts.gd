extends PanelContainer

signal startBuild()
signal endBuild()
signal has_focus(obj)
var open:bool = false
var current_tool = "":
	set(new_focus):
		current_tool = new_focus
		_on_tool_select(current_tool)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_av_button_focused(obj,is_focused):
	current_tool = obj.name
	for c in $VBoxContainer/HBoxContainer.get_children():
		if obj.name != c.get_child(0).name:
			c.get_child(0).focus = false
	
	pass # Replace with function body.

func _on_tool_select(tool):
	_reset_option_lists()
	match(tool):
		"Paint":
			$VBoxContainer/ScrollContainer/PaintOptions.show()
		_:
			print(tool, "selected")

func _reset_option_lists():
	for c in $VBoxContainer/ScrollContainer.get_children():
		c.hide()


func _on_paint_options_item_selected(data):
	Mistro.main.emit_signal("changed_ship_opt","paint",data)
	pass # Replace with function body.


func _on_new_focused(obj_name, is_focused):
	if !open:
		open = true
		emit_signal("startBuild")
	else:
		open = false
		emit_signal("endBuild")
		
	
	
