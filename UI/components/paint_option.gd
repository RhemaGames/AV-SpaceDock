@tool
extends PanelContainer

signal selected(Array)

@export_category("Pallete")
@export var main:Color:
	set(m_new):
		main = m_new
		_change_color(main,"main")
		
@export var secondary:Color:
	set(s_new):
		secondary = s_new
		_change_color(secondary,"secondary")
@export var accent:Color:
	set(a_new):
		accent = a_new
		_change_color(accent,"accent")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Clicked me")
			emit_signal("selected",[main,secondary,accent])

func _change_color(color,type):
	if $VBoxContainer/Control/HFlowContainer/MainColor:
		match(type):
			"main":
				$VBoxContainer/Control/HFlowContainer/MainColor.set_color(color)
			"secondary":
				$VBoxContainer/Control/HFlowContainer/Secondary.set_color(color)
			"accent":
				$VBoxContainer/Control/HFlowContainer/Accent.set_color(color)
