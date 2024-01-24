extends HFlowContainer

signal item_selected(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		if !c.is_connected("selected",Callable(self,"_on_item_selected")):
			c.connect("selected",Callable(self,"_on_item_selected"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_selected(data):
	emit_signal("item_selected",data)
