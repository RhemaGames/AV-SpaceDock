extends CSGMesh3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var closed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open():
	$AnimationPlayer.play("Open")
	closed = false
	
func close():
	$AnimationPlayer.play_backwards("Open")
	closed = true

#func _on_AnimationPlayer_animation_finished(anim_name):
	#if anim_name == "Open" and closed:
#	pass
