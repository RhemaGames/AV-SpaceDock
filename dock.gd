extends Node3D

var docking_bay_open = false
var current_class = []
var current_ship:Dictionary:
	set(new_ship):
		current_ship = new_ship
		cycle_ship(current_ship)
var current_ship_index = 0:
	set(new_ship):
		if new_ship >= 0 and new_ship < current_class.size():
			current_ship_index = new_ship
		else:
			if new_ship < 0: 
				current_ship_index = current_class.size() - 1
			else:
				current_ship_index = 0
		current_ship = current_class[current_ship_index]
		
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
		if $Ship.get_child_count() > 0:
			for c in $Ship.get_children():
				$Ship.remove_child(c)
				c.queue_free()
		if current_ship:
			cycle_ship(current_ship,1)


func _on_visibility_changed():
	Mistro.main.connect("changed_ship_type",Callable(self,"_on_ship_type_changed"))
	Mistro.main.connect("changed_ship_opt",Callable(self,"_on_ship_opt_changed"))

func _on_ship_type_changed(type):
	print_debug("Ship type Changed")
	current_ship = load_ship_class(type)[0]
	current_ship_index = 0
	if docking_bay_open:
		cycle_ship(current_ship)
	else:
		cycle_ship(current_ship,1)
	
	

func load_ship_class(type):
	print_debug("Ship Class Loaded")
	current_class.clear()
	for s in Mistro.ships:
		if s["class"] == type:
			current_class.append(s)
	return current_class

func cycle_ship(ship,step:int = 0):
	if step == 0:
		close_docking_bay()
	else:
		load_ship(ship)
	pass	

func load_ship(ship):
	var the_ship = ship["obj"].instantiate()
	#if $Ship.get_child_count() > 0:
	#	for c in $Ship.get_children():
	#		$Ship.remove_child(c)
	#		c.queue_free()
	ship["stats"] = the_ship.stats
	$Ship.add_child(the_ship)
	Mistro.main.emit_signal("changed_ship",ship)
	open_docking_bay()				

func _unhandled_input(event):
	#if event is InputEventKey and event.is_pressed():
	#	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
	#		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#	else:
	#		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event is InputEventMouseMotion and event.button_mask == 1:
			$Pivot.rotation.y -= event.relative.x * 0.01 
			
			$Pivot.rotation.z -= event.relative.y * 0.01
			$Pivot.rotation.z = clampf($Pivot.rotation.z,-1.5,0.19)

func _on_ship_opt_changed(type,data):
	var ship = $Ship.get_child(0).get_node("Model")
	var opts_to_change
	var materials = {}
	var primary_color
	var secondary_color
	var accent_color
	
	match(type):
		"paint":
			for c in ship.get_children():
				for s in c.mesh.get_surface_count():
					var mat = c.mesh.surface_get_material(s)
					if !mat.resource_name in materials.keys():
						materials[mat.resource_name] = {}
					if !c in materials[mat.resource_name].keys():
						materials[mat.resource_name][c] = []
					materials[mat.resource_name][c].append(s)
					
			for m in materials.keys():
				#print(m,"= ",materials[m].size())
				match(m):
					"primary_color":
						primary_color = materials[m]
					"secondary_color":
						secondary_color = materials[m]
					"accent_color":
						accent_color = materials[m]
					_:
						pass
						
			## Setting primaty color
			print(primary_color)
			if primary_color:
				for _obj in primary_color.keys():
					var _surface = primary_color[_obj]
					_obj.mesh.surface_get_material(_surface[0]).set_albedo(data[0])
					
			## Setting Secondary color
			if secondary_color:
				for _obj in secondary_color.keys():
					var _surface = secondary_color[_obj]
					_obj.mesh.surface_get_material(_surface[0]).set_albedo(data[1])
			
			## Setting accent color
			if accent_color:
				for _obj in accent_color.keys():
					var _surface = accent_color[_obj]
					_obj.mesh.surface_get_material(_surface[0]).set_albedo(data[2])
				
					
