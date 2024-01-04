extends Node3D

var docking_bay_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_docking_bay():
	$AnimationPlayer.play("Open")

func close_docking_bay():
	$AnimationPlayer.play_backwards("Open")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Open" and !docking_bay_open:
		docking_bay_open = true
	elif anim_name == "Open" and docking_bay_open:
		docking_bay_open = false
		
