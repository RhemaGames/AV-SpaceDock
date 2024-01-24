@tool
extends HBoxContainer

@export var stat_max:float = 100.00:
	set(new_max):
		stat_max = new_max
		$Default.set_max(stat_max)
		$Default/Ship.set_max(stat_max)
@export var stat_min:float = 0.0:
	set(new_min):
		stat_min = new_min
		$Default.set_min(stat_min)
		$Default/Ship.set_min(stat_min)
@export var stat_current:float = 0.1:
	set(new_current):
		stat_current = new_current
		$Default/Ship.set_value(stat_current)
		
@export var stat_default:float = 0.1:
	set(new_default):
		stat_default = new_default
		$Default.set_value(stat_default)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = self.name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_renamed():
	$Label.text = self.name
