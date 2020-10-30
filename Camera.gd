extends Camera



func _ready():
	randomize()

func _input(event):
	if event.is_action_pressed("ui_select"):
		var instance = load("res://Dice.tscn").instance()
		get_parent().add_child(instance)
		instance.translation = translation
		instance.doStuff()
		get_parent().dice.append(instance)
		

func setOffset(val):
	h_offset = rand_range(-1,1) * val
	v_offset = rand_range(-1,1) * val
