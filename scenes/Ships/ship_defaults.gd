extends Node

var demo_checks = []
var checked = []
var targetsArray = []
var current_power = 0.0
var tracking = true
var engine_on = false
var current_speed = 0.0
var current_hp = 0.0
var firing = []
@export var ddi:Node3D
@export var engines:Node3D
@export var ui = ""
@export var thrusters:Node3D
@export var targets:Node3D
var targetMarker
@export var model:Node3D
#@export var damage:Node3D
@export var stats:Dictionary
@export var thruster:Node3D
@export var damage:AudioStreamPlayer3D
@export var window_size:Vector2i # = get_viewport().get_size()
#var playerNum = 0:
#	set(new_playerNum):
#		playerNum = new_playerNum
#		layer = playerNum
#		print_debug("Players number is: ",playerNum)

var layer:
	set(new_layer):
		layer = new_layer
		if ddi:
			for i in range(1,9):
				ddi.get_node("Marker").set_layer_mask_value(i,false)
			print_debug("Setting ddi for Layer",layer)
			ddi.get_node("Marker").set_layer_mask_value(layer,true)
		#if ui:
			#for i in range(1,9):
			#	ui.set_visibility_layer_bit(i,false)
			#print_debug("Setting UI for Layer",layer)
			#ui.set_visibility_layer_bit(layer,true)
			#ui.visible = true
			
func all_off():
	engines_off()
	thrusters_off()
	ddi.get_node("Marker/AnimationPlayer").play("RESET")
	targets_off()
	#$UI.visible = false
	#ui.visible = false
	

func engines_off():
	for e in engines.get_children():
	#for e in $Engines.get_children():
		#e.emitting = false
		e.speed = 0

func thrusters_off():
	for t in thrusters.get_children():
		t.emitting = false

func targets_off():
	targetsArray.clear()
	for ar in targets.get_children():
		ar.queue_free()
		targets.remove_child(ar)
		#$Targets.remove_child(ar)
		#ar.visible = false
		#ar.get_node("AnimationPlayer").play("RESET")
		
func locked(is_locked):
	if is_locked:
		if tracking:
			engines_off()
			ddi.get_node("Marker/AnimationPlayer").play_backwards("activate")
			current_power = 0
			tracking = false
	else:
		if !tracking:
			ddi.get_node("Marker/AnimationPlayer").play("activate")
			engine_power(0)
			tracking = true

func paint_target(obj):
	targets.show()
	print_debug("Painting Target: ",obj)
	if targets.get_child_count() <3:
		var the_target = targetMarker.instantiate()
		targets.add_child(the_target)	
		targetsArray.append([the_target,obj])
		the_target.visible = true
		the_target.get_node("AnimationPlayer").play("activate")
		
func take_damage(amount):
	if current_hp - amount > stats.Hull / 2:
		ui.get_node("AnimationPlayer").play("Minor_Damage")
	else:
		ui.get_node("AnimationPlayer").play("Major_Damage")
	if !damage.playing:
		damage.play()
		damage.seek(0.2)	
		ui.get_node("Damage").play()
		
	current_hp -= amount
	ui.hull = current_hp

func engine_power(power):
	#print_debug(" Engine Power: ",power)
	var main_engine = null
	if engines.find_child("main"):
		main_engine = engines.get_node("main")
	
	if engine_on and main_engine:
		if power == 0:
			engines_off()
		elif power <= stats.Speed * 0.5:
			main_engine.speed = power * 0.01
			#main_engine.emitting = true
			#for e in $Engines.get_children():
			#	if e.name != "main":
			#		e.emitting = false
		for e in engines.get_children():
			if e.name != "main":
				if power > stats.Speed * 0.5:
					e.speed = power * 0.01
				else:
					e.speed = 0.0
					#e.emitting = true
		#for e in $Engines.get_children():
		#	if (power / 100) > 0 and (power /100) < 0.2:
		#		e.lifetime = power / 100
			#	e.amount = power 
	else:
		engines_off()

func thruster_direction(directions):
	var engage = []
	if is_instance_valid(thrusters):
		for t in thrusters.get_children():
			t.emitting = false
	#print_debug("Directions: ",directions)
	for direction in directions:
		match direction:
			"left_strafe":
				engage.append(["right"])
			"right_strafe":
				engage.append(["left"])
			"left_turn":
				engage.append(["right","front"])
			"right_turn":
				engage.append(["left","front"])
			"right_turn_sharp":
				engage.append(["left","front"])
				engage.append(["right","rear"])
			"left_turn_sharp":
				engage.append(["right","front"])
				engage.append(["left","rear"])
			"up_strafe":
				engage.append(["bottom"])
			"down_strafe":
				engage.append(["top"])
			"up_tilt":
				engage.append(["bottom","front"])
			"down_tilt":
				engage.append(["top","front"])
			"up_tilt_sharp":
				engage.append(["bottom","front"])
				engage.append(["top","rear"])
			"down_tilt_sharp":
				engage.append(["top","front"])
				engage.append(["bottom","rear"])
			"left_roll":
				engage.append(["right","top"])
			"right_roll":
				engage.append(["left","top"])
			"left_roll_sharp":
				engage.append(["right","top"])
				engage.append(["left","bottom"])
			"right_roll_sharp":
				engage.append(["left","top"])
				engage.append(["right","bottom"])
			_:
				engage = []
				firing = []
				thrusters_off()
	#print_debug("Engaged: ",engage)
	
	for en in engage:
		#print_debug(en)
		for t in thrusters.get_children():
		#for t in $Thrusters.get_children():
			var location = t.name.split("_")
			var burn = false
			var _num = 1
			for e in en:
				if e in ["front","rear","mid"]: 
					if e in location:
						burn = true
					else:
						burn = false
				elif e == location[_num]:
					burn = true
				else:
					burn = false
					break
				_num += 1
			if burn:
				if !t in firing:
					firing.append(t)	
	for t in firing:
		t.emitting = true
		

func set_points():
	for c in model.get_children():
		if c is Marker3D:
			if "thruster" in c.name:
				var t = thruster.instantiate()
				t.name = c.name
				t.position = c.position
				t.rotation = c.rotation
				
				thrusters.add_child(t)
				
	#print_debug($Thrusters.get_children())
			
func update_targets():
	for set in targetsArray:
		var t = set[0]
		var o = set[1]
		if t.position != o.position:
			#print_debug("Updating position for ",t.global_position,"to match ",o.position)
			t.global_position = lerp(t.global_position,o.position, 0.5)
