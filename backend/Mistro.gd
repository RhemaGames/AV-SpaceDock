extends Node

# Mistro is this project's "global" or game wide function set. 
# Function that go here, can be accessed by all other scripts.
# Use this sparingly as noise between scenes and nodes can make your game run slower.

@export var big_list:Dictionary = {}
#var ships:Dictionary = {}
var ships:Array = []
var joypads:Array = []
var current_state = "start"
var current_player = "player1":
	set(new_player):
		current_player = new_player
		emit_signal("player_changed",current_player)
var game_type = null:
	set(gt):
		game_type = gt
		emit_signal("game_type_changed",game_type)
var in_control

signal score_changed(team,score)
signal paused(is_paused)
signal player_status(player,status)
signal state_changed(current_state)
signal player_changed(current_player)
signal game_type_changed(gt)

var player_template = {
	"status":0,
	"ship":{
		"class":"",
		"title": "",
		 "url": "",
		 "obj": null,
		 "about": "",
		 "license": ""
	},
	"playername":"",
	"options":{
		"color":"",
		"decals":"",
		"exhaust":"",
		"dodad1":"",
		"dodad2":""
		}
	}

var players:Dictionary = {
	"player1":player_template.duplicate(),
	"player2":player_template.duplicate(),
	"player3":player_template.duplicate(),
	"player4":player_template.duplicate(),
	"player5":player_template.duplicate(),
	"player6":player_template.duplicate(),
	"player7":player_template.duplicate(),
	"player8":player_template.duplicate(),
}

@export var team1:Dictionary = {
	"teamName":"",
	"teamIndex":1,
	"teammates":{}
	}
@export var team2:Dictionary = {
	"teamName":"",
	"teamIndex":2,
	"teammates":{}
}

@export var control:Dictionary = {
	"team":"",
	"player":""
}

@export var scoreTeam1 = 0:
	set(ne_score):
		scoreTeam1 = ne_score 
		emit_signal("score_changed",0,scoreTeam1)
@export var scoreTeam2 = 0:
	set(ne_score):
		scoreTeam2 = ne_score
		emit_signal("score_changed",1,scoreTeam2)
		
var ship_class_base_stats:Dictionary = {
	"Striker":{
		"Hull":30,
		"Speed":270,
		"Turn":0.5,
		"Accel":50
		},
	"Midfield":{
		"Hull":100,
		"Speed":200,
		"Turn":50,
		"Accel":30
		},
	"Defender":{
		"Hull":200,
		"Speed":150,
		"Turn":40,
		"Accel":15
		},
	"Template":{
		"Hull":100,
		"Speed":150,
		"Turn":40,
		"Accel":15
		}	
}

## Audio variables

var previous_music_volume:float = 0.0
var previous_ambient_volume:float = 0.0
var previous_sfx_volume:float = 0.0
var previous_master_volume:float = 0.0

var current_music_volume:float = 0.0
var current_ambient_volume:float = 0.0
var current_sfx_volume:float = 0.0
var current_master_volume:float = 0.0

var previous_music_muted:bool = false
var previous_ambient_mutec:bool = false
var previous_sfx_muted:bool = false
var previous_master_muted:bool = false


var game_settings = {
	"time":100*2,
	"score":3,
	"opponets": 6,
	"bots": true,
	"auto_balance": true
}

var main

# Called when the node enters the scene tree for the first time.
func _ready():
	joypads = Input.get_connected_joypads()
	#print_debug(joypads)
	Input.connect("joy_connection_changed",Callable(self,"_on_joy_connection_changed"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func create_big_list(path):
	var dir = DirAccess.open(path)
	#print_debug(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var starting_point = path.split("/")[-1]
		if !big_list.has(starting_point):
			big_list[starting_point] = {}
		while file_name != "":
			var _returned:Array = []
			if dir.current_is_dir():
				if !big_list[starting_point].has(file_name):
					big_list[starting_point][file_name] = {}
					var schema = {"title":"",
									"url":"",
									"obj":null,
									"about":"",
									"class":"",
									"license":"",
									}
					_returned = IoLinux.recursive_search(starting_point,["tscn","pck","tscn.remap"],["imgs","sfx","components","model","shaders"],path+"/"+file_name,big_list,schema)
					#print_debug(returned)
			#else:
			#	print_debug(file_name)
				#if file_name.get_extension() == "pck":
				#	print_debug("importing ",path+file_name)
				#	var success = ProjectSettings.load_resource_pack(path+file_name)
				#	if success:
				#		print_debug("Loaded file")
						
					
			file_name = dir.get_next()
		return 1
	
#func global_physics(object,):
#	print("applying global physics")

func turn_and_catch(catcher,catchlocation,obj,_lerp : Vector3):
	var direction = catcher.rotation
	#catcher.rotation.y = lerp_angle(catcher.rotation.y, atan2(direction.x, direction.z), 0.06)
	#catcher.rotation.x = lerp_angle(catcher.rotation.x, atan2(direction.y, direction.z), 0.06)
	#catcher.rotation.z = lerp_angle(catcher.rotation.z, atan2(direction.y, direction.x), 0.06)
	
	#catcher.look_at(obj.position,Vector3.UP)
	#var current_point = catchlocation.transform
	#var to_point = catchlocation.transform.looking_at(obj.position,catcher.on_lookat_vector)
	#print(current_point.basis)
	#print(to_point.basis)
	#var first_point = catchlocation.get_global_position()
	#var second_point = obj.get_global_position()
	#var ang2 = first_point.direction_to(second_point).angle()
	#print("Direction to disc: ",ang2)
	#var slerpy = first_point.slerp(ang2,0.1)
	#catcher.rotate_x(slerpy.x)
	#if int(abs(slerpy.y)) != 0:
	#print(slerpy.y)
	#	catcher.rotate_y(slerpy.y)
		
	var objTransAbs = Vector3(
					int(abs(obj.position.x)),
					int(abs(obj.position.y)),
					int(abs(obj.position.z))
					)
	
	var catchLocAbs = Vector3(
						int(abs(catchlocation.get_global_position().x)),
						int(abs(catchlocation.get_global_position().y)),
						int(abs(catchlocation.get_global_position().z))
						)

	if objTransAbs == catchLocAbs: 
		catcher.has_disc = true
		obj.captured(catchlocation)
		catcher.catch_sequence = false
		
	#return slerpy


func find_target(targets_list):
	var targetIndex = randi() % len(targets_list.get_children())
	var target = targets_list.get_child(targetIndex)
	return target


func load_ships():
	if "Ships" in big_list:
		#print_debug(big_list)
		for classes in big_list["Ships"].keys():
			for ship in big_list["Ships"][classes].keys():
				var new_url = ""
				if big_list["Ships"][classes][ship]["url"].get_extension() == "tscn":
					new_url = big_list["Ships"][classes][ship]["url"]
				elif big_list["Ships"][classes][ship]["url"].get_extension() == "remap":
					new_url = big_list["Ships"][classes][ship]["url"].split(".remap")[0]
				else:
					var success = ProjectSettings.load_resource_pack(big_list["Ships"][classes][ship]["url"],false,0)
					if success:
						res_search("res://")
						new_url = "res://scenes/"+big_list["Ships"][classes][ship]["url"].get_basename().split("://")[1]+".tscn"
						
				if new_url != "":
					big_list["Ships"][classes][ship]["obj"] = load(new_url)
					big_list["Ships"][classes][ship]["about"] = new_url.split(".")[0]+".md"
					big_list["Ships"][classes][ship]["class"] = classes
					big_list["Ships"][classes][ship]["license"] = new_url.get_base_dir()+"/license.md"
					ships.append(big_list["Ships"][classes][ship])
				
	return ships

func autopilot(obj,end):
	randomize()
	var num_of_points = randi_range(2,4)
	#var num_of_points = 3
	var points:Array = []
	points.append(obj.position)
	
	for p in num_of_points:
		randomize()
		var x_offset = 10
		randomize()
		var y_offset = 20
		randomize()
		var z_offset = 30
		var new_point:Vector3 = Vector3.ZERO
		var halfises = lerp(points[-1],end,randf_range(0.3,0.7))
		new_point.x = halfises.x + x_offset
		new_point.y = halfises.y + y_offset
		new_point.z = halfises.z + z_offset
		points.append(new_point)
	points.append(end)	

	var curve = Curve3D.new()
	
	for p in points:
		#print(p)
		curve.add_point(p,Vector3(-10,40,-15),Vector3(10,-40,14))
	return curve

func get_from_catalog(depth,cat):
	#print_debug("(",depth.size(),")",depth," ",cat)
	match depth.size():
		2:
			if cat in big_list[depth[1]]:
				return big_list[depth[1]][cat]
		3:
			if cat in big_list[depth[1]][depth[2]]:
				return big_list[depth[1]][depth[2]][cat]
			elif big_list[depth[1]][depth[2]] is Array:
				for c in big_list[depth[1]][depth[2]]:
					if c["title"] == cat:
						return c
		4:
			if cat in big_list[depth[1]][depth[2]][depth[3]]:
				return big_list[depth[1]][depth[2]][depth[3]][cat]
		_:
			if cat in big_list:
				return big_list[cat]

func res_search(path):
	var dir = DirAccess.open(path)
	#print_debug(path)
	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = dir.get_next()
	var starting_point = path.split("/")[-1]
	if !big_list.has(starting_point):
		big_list[starting_point] = {}
	while file_name != "":
		if dir.current_is_dir():
			print_debug("Found directory ",file_name)
		else:
			print_debug(file_name)
			
		file_name = dir.get_next()

@rpc("call_local")		
func update_score(team,point):
	
	if team == 1:
		scoreTeam1 += point
	else:
		scoreTeam2 += point

func start_level():
	print_debug("Print Starting Level")
	
	pass

func _on_joypad_connection_changed():
	joypads = Input.get_connected_joypads()
	print_debug("New joypad")


func set_state(new_state):
	current_state = new_state
	emit_signal("state_changed",current_state)

func set_player(new_player):
	current_player = new_player
	emit_signal("player_changed",current_player)

func get_player(shortname):
	var fullname = ""
	match shortname:
		"p1":
			fullname = "player1"
		"p2":
			fullname = "player2"
		"p3":
			fullname = "player3"
		"p4":
			fullname = "player4"
		"p5":
			fullname = "player5"
		"p6":
			fullname = "player6"
		"p7":
			fullname = "player7"
		"p8":
			fullname = "player8"
			
	return fullname

func fill_teams():
	var num_of_players = 0
	if game_settings.bots: 
		while game_settings.opponets > num_of_players:
			for p in Mistro.players:
				if Mistro.players[p].status != 0:
					num_of_players +=1
			if game_settings.opponets > num_of_players:
				for p in Mistro.players:
					if Mistro.players[p].status == 0:
						add_bot(Mistro.players[p])
	return true

func add_bot(position):
	var shp = load_ships()
	var randm_ship = shp[randi_range(0,shp.size()-1)]
	position.ship = randm_ship
	position.status = 4
	position.playername = "bot"

func reset():
	for p in players.keys():
		players[p].clear()
		players[p] = player_template.duplicate()
	team1.teammates.clear()
	team2.teammates.clear()
	team1.teamName = ""
	team2.teamName = ""
	scoreTeam1 = 0
	scoreTeam2 = 0
	#print_debug(players)
	#print_debug(team1)
	#print_debug(team2)

func set_world(shortname):
	var tutorial = load("res://scenes/World/City/city_level.tscn")
	var level = tutorial.instantiate()
	main.background.add_child(level)
