extends RigidBody3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_captured = false
var capture = null
var core_parent = null
var launched_by = null

signal change_hands(new_hand)
# Called when the node enters the scene tree for the first time.
func _ready():
	set_freeze_mode(RigidBody3D.FREEZE_MODE_STATIC)
	core_parent = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
		if is_captured:
			position = capture.get_global_position()
			rotation = capture.get_global_rotation()
			

func captured(obj):
	freeze = true
	sleeping = true
	if position.distance_to(obj.get_global_position()) < 3:
		is_captured = true
		capture = obj
		emit_signal("change_hands",obj.get_parent().get_parent())
		return true
	else:
		position = lerp(position,obj.get_global_position(),0.6)
		rotation = lerp(rotation,obj.get_global_rotation(),0.6)
		return false


func launch(obj):
	if capture:
		if capture.get_parent().get_parent().name == obj.get_parent().get_parent().name:
			print_debug("On Launch captured: ",capture.get_parent().get_parent().name)
			print_debug("On Launch recieved from: ",obj.get_parent().get_parent().name)
			freeze = false
			sleeping = false
			is_captured = false
			capture = null
	#obj.remove_child(self)
	#core_parent.add_child(self)
	#self.name = "Disc"
			position = obj.get_global_position()
			rotation = obj.get_global_rotation()
			launched_by = obj.get_parent()
			angular_velocity = (transform.basis * Vector3(0,1500,0))
			apply_central_impulse(transform.basis * Vector3(1,1,-400))
