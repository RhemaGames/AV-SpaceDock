extends Node3D

var ship
var has_disc = false
var disc = null
var disc_in_range = false
var catch_sequence = false
var on_lookat_vector:Vector3
var catch = true
var slerp:Vector3
signal is_open(obj)
signal in_posession(obj)

var called_out = []
var myteam = []

# Called when the node enters the scene tree for the first time.
func _ready():
	on_lookat_vector = self.position
	ship = $Ship
	disc = get_parent().get_parent().get_node("Disc")
	self.add_to_group("Team1")
	self.add_to_group("Drones")
	Mistro.team1["teammates"].append(self)
	update_my_team()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if position.distance_to(disc.position) < 40:
		_on_CatchRange_body_entered(disc)
		if position.distance_to(disc.position) < 12 and catch:
			_on_CatchRangeClose_body_entered(disc)
	else:
		_on_CatchRange_body_exited(disc)
		
func _physics_process(delta):
	if !disc_in_range:
		catch_sequence = false
	else:
		catch_sequence = true
		
	if catch_sequence and catch:
		Mistro.turn_and_catch(self,self.ship.find_child("DiscLock"),disc,slerp)
	
	if has_disc:
		Mistro.control["team"] = "team1"
		Mistro.control["player"] = self	
		emit_signal("in_posession",self)
	

func _on_CatchRange_body_entered(body):
	if "Disc" in body.get_groups() and catch:
		disc_in_range = true
		position = body.position


func _on_CatchRange_body_exited(body):
	
	if "Disc" in body.get_groups():
		disc_in_range = false
		

func _on_launch():
	if ship and has_disc:
		disc.launch(ship.get_node("DiscLock"))
		has_disc = false
		catch = false
		$CatchTimer.start()


func _on_CatchRangeClose_body_entered(body):
	if "Disc" in body.get_groups():
		#print_debug("Drone catching")
		disc = body
		disc_in_range = true
		if catch_sequence:
			disc.captured(ship.get_node("DiscLock"))
			has_disc = true
			catch_sequence = false
			catch = false
			$Timer.start()


func _on_CatchRangeClose_body_exited(body):
	pass # Replace with function body.


func _on_Timer_timeout():	
	_on_launch()
	$Timer.stop()

func _on_CatchTimer_timeout():
	catch = true
	$CatchTimer.stop()

func _on_team_posession(obj):
	#print(obj.name," Has posession")
	randomize()
	var will_callout = randi()
	if Mistro.control["team"] == "team1" and Mistro.control["player"] != self:
		if will_callout % 5 == 0:
			emit_signal("is_open",self)
	#print("Who has the disc?: ",obj)

func _on_is_open(obj):
	if has_disc:
		#print_debug(obj," is Open!")
		if called_out.size() < 3:
			if !obj in called_out:
				called_out.append(obj)


func update_my_team():
	if Mistro.team1["teammates"].size() >= myteam.size():
		myteam = Mistro.team1["teammates"]
		for team in myteam:
			if team != self:
				if !team.is_connected("in_posession",Callable(self,"_on_team_posession")):
					team.connect("in_posession",Callable(self,"_on_team_posession"))
					team.connect("is_open",Callable(self,"_on_is_open"))			
		

func ai():
	update_my_team()
	if has_disc:
		# Pick target
		randomize()
		var target = int(randf_range(0,called_out.size()))
		#print_debug("Targets: ",called_out)
		if called_out.size() > target:
			look_at(myteam[target].get_global_position(),position)
			_on_launch()
			print_debug("Targetting ",myteam[target].name)	


func _on_AI_timeout():
	ai()
	pass # Replace with function body.
