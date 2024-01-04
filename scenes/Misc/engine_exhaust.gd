#@tool
extends Node3D
@export var speed:float = 0.000:
	set(new_speed):
		speed = new_speed
		_on_speed_change(speed)

@export var rotation_speed:float = 2.000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$engine_exhaust_default.rotation.y += rotation_speed * delta
	
	pass


func _on_speed_change(speed):
	if speed > 0:
		if !$AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.play()
		$engine_exhaust_default/Cone.scale = Vector3(1,speed,1)
	else:
		$engine_exhaust_default/Cone.scale = Vector3(1,0.1,1)
		$AudioStreamPlayer3D.stop()
		if speed > 0.0:
			$AudioStreamPlayer3D.pitch_scale = speed
		else:
			$AudioStreamPlayer3D.pitch_scale = 0.1
