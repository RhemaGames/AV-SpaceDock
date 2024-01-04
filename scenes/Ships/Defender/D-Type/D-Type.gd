extends Node3D

var thruster_burst = preload("res://scenes/Ships/Defender/D-Type/components/Thuster_particle.tscn")
var target = preload("res://scenes/Ships/Defender/D-Type/components/target.tscn")
var version = 0.1
signal died()
signal damaged()
const stats:Dictionary = {
	"Name":"Catamaran",
	"Hull":100,
	"Speed":240,
	"Turn":50,
	"Accel":50
}
var ship:Node
# Called when the node enters the scene tree for the first time.
func _ready():
	ship = $Build
	ship.ddi = $DDI
	ship.engines = $Engines
	ship.ui = $UI
	ship.thrusters = $Thrusters
	ship.targets = $Targets
	ship.targetMarker = target
	ship.model = $Model
	ship.stats = stats
	ship.thruster = thruster_burst
	ship.damage = $Damage
	
	
	ship.current_hp = stats.Hull
	$Targets.top_level = true
	ship.set_points()
	ship.all_off()
	

func _on_demo_timer_timeout():
	$DDI.Marker.AnimationPlayer.play("activate")
	$Targets.get_child(0).get_node("AnimationPlayer").play("activate")
	if ship.current_power < 100:
		ship.engine_power(ship.current_power)
		ship.current_power += 3.0
	ship.thruster_direction(["off"])
	if ship.current_hp > 0:
		ship.take_damage(10)
	
func _on_ui_visibility_changed():
	if $UI.visible:
		var window_size = get_viewport().get_size()
		#if Vector2i($UI.size) != Vector2i(window_size):
		#	$UI.set_size(window_size)
		#	$UI.set_anchors_preset(Control.PRESET_FULL_RECT)
