
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass

func _physics_process(delta):
	$Cylinder.rotate_y(0.8*delta)
	$Cylinder_001.rotate_z(0.8*delta)
	$Cylinder_002.rotate_y(-0.8*delta)
