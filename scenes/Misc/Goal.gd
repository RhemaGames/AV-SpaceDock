
extends Node3D

var outerring
var outerring_spin = 0.1
var can_score:bool = true
@export var team = 1
@export var team_color = StandardMaterial3D
# Called when the node enters the scene tree for the first time.
func _ready():
	#$Goal_Area
	outerring = $"OuterRing "
	$"InnerRing ".set_surface_override_material(0,team_color)
	$"OuterRing ".set_surface_override_material(1,team_color)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _physics_process(delta):
	outerring.rotate_z(delta * outerring_spin)

func _on_goal_area_body_entered(body):
	if "Disc" in body.get_groups() and can_score:
		#print("GOOOOALLLLAALALALAA")
		outerring_spin = 10
		$Timer.start()
		print(body.launched_by.name)
		Mistro.update_score(team,1)
		can_score = false
		
	#if "Ship" in body.get_groups():
	#	print("Hello There")


func _on_timer_timeout():
	outerring_spin = 0.1
	can_score = true
