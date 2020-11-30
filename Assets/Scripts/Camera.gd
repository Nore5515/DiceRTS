extends Camera

var holding = true
var speed = 0.003

var upDown = 0

func _ready():
	randomize()

func _input(event):
	if event.is_action_pressed("ui_select") && get_parent().YOURTURN:
		if get_parent().alliedDice > 0:
			spawnDice(true)
			get_parent().alliedDice -= 1
	
	if event.is_action_pressed("mmb"):
		holding = true
	if event.is_action_released("mmb"):
		holding = true
	
	if event is InputEventMouseMotion && holding:
		if event.speed.x < 0:
			rotation_degrees.y += -speed * event.speed.x
			if rotation_degrees.y > 45:
				rotation_degrees.y = 45
		if event.speed.x > 0:
			rotation_degrees.y += -speed * event.speed.x
			if rotation_degrees.y < -45:
				rotation_degrees.y = -45
	
	if event.is_action_pressed("scrollUp"):
		if upDown < 30:
			translation += (Vector3(0,0.5,0.5))
			upDown += 1
	if event.is_action_pressed("scrollDown"):
		if upDown > -30:
			translation += (Vector3(0,-0.5,-0.5))
			upDown -= 1
		

func spawnDice(isPlayer):
	var instance = load("res://Scenes/Dice.tscn").instance()
	get_parent().add_child(instance)
	instance.translation = translation
	instance.rotation = rotation
	instance.doStuff()
	get_parent().dice.append(instance)
	if isPlayer:
		instance.team = 1
	else:
		
		instance.team = 2

func setOffset(val):
	h_offset = rand_range(-1,1) * val
	v_offset = rand_range(-1,1) * val
