extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for c in [%Color_SelectB,%Color_SelectR,%Color_SelectG]:
		if !c.is_connected("color_changed",Callable(self,"_on_color_changed")):
			c.connect("color_changed",Callable(self,"_on_color_changed"));
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_color_changed(c_value,value):
	print(c_value,value)
