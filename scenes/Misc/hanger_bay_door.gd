extends CSGMesh3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var closed = true
@export var current_ship:Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func clear_ship():
	if $hanger_bay_door/hanger_lift.get_child_count() > 0:
		var node = $hanger_bay_door/hanger_lift.get_child(0)
		$hanger_bay_door/hanger_lift.remove_child(node)
		node.queue_free()

func load_ship(ship):
	var player_ship = ship.instantiate()
	$hanger_bay_door/hanger_lift.add_child(player_ship)
	player_ship.translate(Vector3(0.0,2.3,0.0))
	current_ship = player_ship
	open()

func open():
	$AnimationPlayer.play("Open")
	closed = false
	
func close():
	$AnimationPlayer.play_backwards("Open")
	closed = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Open" and closed:
		clear_ship()
		
		
	pass # Replace with function body.
