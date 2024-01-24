@tool
extends Panel

@onready var icon = $Paint
var true_parent = get_parent()

var original_size:Vector2
var original_fg_color:Color
var original_bg_color:Color
var original_texture:Texture2D

@export_enum("Begin","Middle","End","Single") var style:int = 0:
	set(new_style):
		style = new_style
		set_style(style)

var types = [preload("res://UI/components/av_menu_buttom_left.stylebox"),
preload("res://UI/components/av_menu_buttom_internal.stylebox"),
preload("res://UI/components/av_menu_buttom_right.stylebox"),
preload("res://UI/components/av_menu_button_single.stylebox")]

@export_category("Visuals")
@export var background_color:Color = Color(1,1,1,1):
	set(new_Color):
		background_color = new_Color
		_update_color("background")
@export var foreground_color:Color = Color(1,1,1,1):
	set(new_Color):
		foreground_color = new_Color
		_update_color("foreground")
@export var texture:Texture2D: 
	set(new_texture):
		texture = new_texture
		_update_texture(texture)
		
@export var Text_not_Texture:bool = false:
	set(tnt):
		Text_not_Texture = tnt
		if tnt == false:
			$Paint.visible = true
			$Label.visible = false
		else:
			$Paint.visible = false
			$Label.visible = true
@export var text:String:
	set(new_text):
		text = new_text
		if Text_not_Texture == true:
			$Label.text = text

@export_category("Geometry")
@export var width:float = 128.0:
	set(new_width):
		width = new_width
		_update_size(width,height)
@export var height:float = 64.0:
	set(new_height):
		height = new_height
		_update_size(width,height)	
		
@export_range(1,2) var grow = 1.0

@export var toggle:bool = true


@export var focus = false:
	set(new_focus):
		focus = new_focus
		_update_focus(focus)
		
signal focused(obj_name,is_focused)

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_texture(texture)
	_update_size(width,height)
	_update_color("background")
	_update_color("foreground")
	if !original_size and focus:
		original_size = Vector2(width /2 ,height /2)
	else:
		original_size = Vector2(width,height)
	original_bg_color = background_color
	original_fg_color = foreground_color
	original_texture = texture
	
	if get_parent() is Control: 
		true_parent = get_parent().get_parent()
	else:
		true_parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	$Paint.rotation = delta * 0.1
#	pass


func _update_texture(p_texture):
	if icon:
		icon.texture = p_texture
		icon.size = Vector2(height*0.8,height*0.8)
		icon.custom_minimum_size = Vector2(height*0.8,height*0.8)
		icon.pivot_offset = icon.size / 2
		icon.position = Vector2(width*0.5 - icon.size.x / 2,(height*0.5) - icon.size.y / 2)

func _update_color(type):
	match type:
		"background":
			set_self_modulate(background_color)
			
		"foreground":
			if icon:
				icon.set_self_modulate(foreground_color)
				$Label.set_self_modulate(foreground_color)
				for c in [$ColorRect,$ColorRect2,$ColorRect3]:
					c.set_self_modulate(foreground_color)
			
func _update_size(p_width,p_height):
	size = Vector2(p_width,p_height)
	custom_minimum_size = Vector2(p_width,p_height)
	if icon:
		icon.size = Vector2(p_height*0.8,p_height*0.8)
		icon.custom_minimum_size = Vector2(p_height*0.8,p_height*0.8)
		icon.pivot_offset = icon.size / 2
		icon.position = Vector2(p_width*0.5 - icon.size.x / 2 ,(p_height*0.5) - icon.size.y / 2)
		



func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if toggle:
			if !self.focus: 
				focus = true
				emit_signal("focused",self,focus)
		else:
			emit_signal("focused",self,focus)

func _on_parent_has_focus(obj):
	print(obj.name)
	


func _on_focused(obj, is_focused):
	print("from on_focused",obj.name,is_focused)
	pass # Replace with function body.

func _update_focus(p_focus):
	if get_parent() is Control: 
		if p_focus:
			get_parent().size.x = width * grow
			get_parent().custom_minimum_size.x = width * grow
			width = width * grow
			height = height * grow
		else:
			get_parent().size = original_size
			get_parent().custom_minimum_size = original_size
			width = original_size.x
			height = original_size.y
			
		_update_size(width,height)

func set_style(style):
	#print(types[style])
	add_theme_stylebox_override("panel",types[style])
	#set_property("theme_override_styles/panel") = types[0]
	pass
