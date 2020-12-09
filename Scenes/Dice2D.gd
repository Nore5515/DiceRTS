extends Sprite



var value = 0
var waitTime 
var waitValues = [0.45, 0.25, 1.0, 0.4]

export (float) var drag = 0.05

var rolling = false

var sizing
var baseSizing = 0.9
var sizingRate = 0.001

var tempo = 0
var maxTempo = 1

# .45, .25, 1.0, 0.4

func _ready():
	waitTime = randi()%4
	roll()


func _input(event):
	if event.is_action_pressed("Ctrl"):
		roll()


func _process(delta):
	
	if rolling == true:
		if tempo >= maxTempo:
			changeFace(randi()%7)
			tempo = 0
		else:
			tempo += 1
		
		if $Timer.time_left < 0.2:
			get_parent().linear_velocity = lerp(get_parent().linear_velocity, Vector2(0,0), drag)
			get_parent().angular_velocity = lerp(get_parent().angular_velocity, 0, drag)
		
		if sizing > 0:
			get_parent().scale = Vector2(get_parent().scale.x + sizingRate,get_parent().scale.y + sizingRate)
			sizing -= sizingRate
	else:
		if get_parent().linear_velocity != Vector2(0,0):
			get_parent().linear_velocity = lerp(get_parent().linear_velocity, Vector2(0,0), drag * 4)
		if get_parent().angular_velocity != 0:
			get_parent().angular_velocity = lerp(get_parent().angular_velocity, 0, drag * 16)


func roll():
	rolling = true
	sizing = baseSizing
	get_parent().scale = Vector2(1 - baseSizing,1 - baseSizing)
	waitTime = randi()%4
	$Timer.wait_time = waitValues[waitTime]
	if waitTime == 0:
		$audio.stream = load("res://Assets/Sounds/dice1.wav")
	elif waitTime == 1:
		$audio.stream = load("res://Assets/Sounds/dice2.wav")
	elif waitTime == 2:
		$audio.stream = load("res://Assets/Sounds/dice3.wav")
	elif waitTime == 3:
		$audio.stream = load("res://Assets/Sounds/dice4.wav")
	$audio.play()
	$Timer.start()
	
	get_parent().linear_velocity = Vector2(2500 * rand_range(-1,1), 2500 * rand_range(-1,1))
	get_parent().angular_velocity = 90 * rand_range(-1,1)



func changeFace(face: int):
	value = face
	if face == 1:
		texture = load("res://Assets/Art/newstuff/dice/1.png")
	elif face == 2:
		texture = load("res://Assets/Art/newstuff/dice/2.png")
	elif face == 3:
		texture = load("res://Assets/Art/newstuff/dice/3.png")
	elif face == 4:
		texture = load("res://Assets/Art/newstuff/dice/4.png")
	elif face == 5:
		texture = load("res://Assets/Art/newstuff/dice/5.png")
	elif face == 6:
		texture = load("res://Assets/Art/newstuff/dice/6.png")


func _on_Timer_timeout():
	get_parent().linear_velocity = Vector2(0,0)
	#get_parent().applied_force = Vector2(0,0)
	#get_parent().angular_velocity = 0
	rolling = false
