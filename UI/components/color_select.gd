extends HBoxContainer

@export var title:String
@export_enum("R","G","B") var color_value 
signal color_changed(color_value,value)

var current_R = 1
var current_G = 1
var current_B = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	$title.text = title
	$Color_Select/HSlider.value = 255
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_h_slider_value_changed(value):
	emit_signal("color_changed",color_value,value)
	if color_value == 0:
		$Color_Select/ColorRect.color = Color(1,value/255,value/255)
	if color_value == 1:
		$Color_Select/ColorRect.color = Color(value/255,1,value/255)
	if color_value == 2:
		$Color_Select/ColorRect.color = Color(value/255,value/255,1)	
