extends Node2D

var power_level = 0:
	set(power_lvl):
		power_level = power_lvl
		set_power_level(power_level)
var tractor_power = 0:
	set(tractor_pwr):
		tractor_power = tractor_pwr
		set_tractor_power(tractor_power)

var hull = 0:
	set(hull_strength):
		hull = hull_strength
		set_hull_strength(hull)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_power_level(power):
	if power > 0:
		$PowerLevel/ThrustContainer/Forward.scale.y = power
	else:
		$PowerLevel/ThrustContainer/Reverse.scale.y = abs(power)
func set_tractor_power(power):
	$PowerLevel/TractorContainer/Energy.scale.y = power

func set_hull_strength(strength):
	$HullSpecial/Hull.scale.x = strength
