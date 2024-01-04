extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$HIVE.call_deferred("get_profile","bflanagin")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_hive_recieved_profile(json):
	$RichTextLabel.text = str(json)
	pass # Replace with function body.
