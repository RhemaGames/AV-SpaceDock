extends Node3D

var thruster_burst = preload("res://scenes/Ships/Striker/S-Type/components/Thuster_particle.tscn")
var target = preload("res://scenes/Ships/Striker/S-Type/components/target.tscn")
var version = 0.1
signal died()
signal damaged()
const stats:Dictionary = {
	"Name":"S-Type",
	"Hull":40.00,
	"Speed":270.00,
	"Turn":0.60,
	"Accel":10.00
}
var ship:Node
# Called when the node enters the scene tree for the first time.
func _ready():
	ship = $Build
	ship.ui = $UI

	ship.stats = stats
	ship.thruster = thruster_burst.instantiate()
	ship.targetMarker = target
	#ship.damage = $Damage
	
	ship.current_hp = stats.Hull
	#1s$Targets.top_level = true
	ship.set_points()
	ship.all_off()
	ship.ui.hull = stats["Hull"]
	#$demo_timer.start()

func _on_demo_timer_timeout():
	$DDI.get_node("Marker/AnimationPlayer").play("activate")
	#$Targets.get_child(0).get_node("AnimationPlayer").play("activate")
	if ship.current_power < 100:
		ship.engine_power(ship.current_power)
		ship.current_power += 3.0
	ship.thruster_direction(["off"])
	if ship.current_hp > 0:
		ship.take_damage(10)
	
func _on_ui_visibility_changed():
	pass
	#if $UI.visible:
	#	var window_size:Vector2i = get_viewport().get_size()
	#	if Vector2i($UI.size) != Vector2i(window_size):
		#	$UI.set_size(window_size)
		#	$UI.set_anchors_preset(Control.PRESET_FULL_RECT)
