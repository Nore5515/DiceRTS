extends KinematicBody2D



var HP = 3
var attack = 3

var defense = 3
var baseDefense = 3

var detectionRange = 800
var baseDetectionRange = 800

export (int) var team = 0

export (float) var speed = 100
var baseSpeed = 100
var dest
var moving = false

var temp = 0

var MOUSE_OVER = false
var SELECTED = false
var PAUSED = false


var DETECTED = false
var detectedUnit
var detectedUnits = []

var SLOWED = false
var MEGASLOWED = false

var ACTIVATED = false

var DEAD = false

var DIGGING_PROGRESS = 0
var DIGGING_MAX = 3
var DIGGING_IN = false
var DUGIN = false

var isVehicle = false
var isArt = false

var tag = ""

func saveMe():
	var type
	
	if isVehicle:
		type = "Veh"
	elif isArt:
		type = "Art"
	else:
		type = "Inf"
	
	var data = {
		"type": type,
		"global_pos": global_position,
		"HP": HP,
		"digProgress": DIGGING_PROGRESS,
		"slowed": SLOWED,
		"megaSlowed": MEGASLOWED,
		"dugin": DUGIN,
		"dead": DEAD,
		"team": team,
		"tag": tag
	}
	return data

func loadMe(data):
	#print ("LOADING ", name, data)
	global_position = data["global_pos"]
	HP = data["HP"]
	DIGGING_PROGRESS = data["digProgress"]
	SLOWED = data["slowed"]
	MEGASLOWED = data["megaSlowed"]
	DUGIN = data["dugin"]
	DEAD = data["dead"]
	team = data["team"]
	tag = data["tag"]



func _ready():
	if SLOWED:
		speed = baseSpeed * 0.5
	if MEGASLOWED:
		speed = baseSpeed * 0.2
	if isArt:
		$Timer.wait_time = 0.8
	
	if DEAD:
		ACTIVATED = false
		$inf.modulate = Color($inf.modulate.r * 0.2, $inf.modulate.g * 0.2, $inf.modulate.b * 0.2)
	
	if tag == "":
		for x in range(10):
			tag += String(randi() % 10)
	

func paint(newColor):
	$inf.modulate = newColor
	$target.modulate = newColor


func _on_InfUnit_mouse_entered():
	#print ("over")
	MOUSE_OVER = true


func _on_InfUnit_mouse_exited():
	#print ("not")
	MOUSE_OVER = false


func getNearest(listUnits):
	#print ("Getting nearest!")
	var nearestPos = Vector2(1000000,1000000)
	var myPos = global_position
	var theirPos
	var nearestUnit
	
	for unit in listUnits:
		#print ("unitScanned: ", unit.saveMe())
		theirPos = unit.global_position
		if theirPos.distance_to(myPos) < nearestPos.distance_to(myPos):
			if unit.team != team:
				nearestUnit = unit
				nearestPos = nearestUnit.global_position
				#print ("found one!")
	
	#if nearestUnit == null:
		#print("Uh oh! I failed!", name, team, saveMe())
	
	return nearestUnit


func _process(delta):
	$HP.text = String(HP)
	if !DEAD:
		
		if PAUSED:
			if $Timer.paused == false:
				$Timer.paused = true
		else:
			if $Timer.paused == true:
				$Timer.paused = false
			
		
		if SLOWED:
			speed = baseSpeed * 0.5
			if $slowArrow.visible == false:
				$slowArrow.visible = true
		elif MEGASLOWED:
			speed = baseSpeed * 0.2
			if $slowArrow.visible == false:
				$slowArrow.visible = true
			if $slowArrow2.visible == false:
				$slowArrow2.visible = true
		else:
			speed = baseSpeed
			if $slowArrow.visible == true:
				$slowArrow.visible = false
			if $slowArrow2.visible == true:
				$slowArrow2.visible = false
		
		# DO THIS ONCE DUGIN
		if DUGIN:
			$shield.visible = true
			if isArt:
				detectionRange = 6000
				attack = 7
			else:
				detectionRange = round (baseDetectionRange * 0.5)
				attack = ceil(baseDefense * 1.5)
		
		# IF YOU'RE DIGGING IN, THEN
		if DIGGING_IN:
			if DIGGING_PROGRESS < DIGGING_MAX:
				if $Timer.is_stopped() && !PAUSED:
					$Timer.start()
			else:
				DUGIN = true
		else:
			# YOU STOPPED DIGGING!
			if DUGIN:
				DUGIN = false
				$shield.visible = false
				attack = baseDefense
				detectionRange = baseDetectionRange
				$dot.visible = false
				$dot2.visible = false
				$dot3.visible = false
				DIGGING_PROGRESS = 0
		
		if isVehicle == false && !PAUSED:
			if moving:
				if detectionRange != baseDetectionRange:
					#print ("Moving now!")
					DIGGING_IN = false
					#$shield.visible = false
			else:
				if detectionRange != round(baseDetectionRange * 0.5):
					#print ("stopped moving!")
					DIGGING_IN = true

		if $Detection/CollisionShape2D.shape.radius != detectionRange:
			$Detection/CollisionShape2D.shape.radius = detectionRange
		
		if moving == true && PAUSED == false:
			$target.global_position = dest
			$target.visible = true
			var dir = dest - self.global_position
			dir = dir * 100000
			dir = dir.clamped(speed)
			move_and_collide(dir * delta)
			if self.global_position.distance_to(dest) < 5:
				moving = false
		elif moving == true && PAUSED == true:
			$target.global_position = dest
			$target.visible = true
		else:
			$target.visible = false
		
		
		if SELECTED:
			$box.visible = true
		else:
			$box.visible = false
		


func _on_Detection_body_entered(body):
	if body.is_in_group("Unit") && ACTIVATED:
		if body.team != team:
			print (name, " has detected unit ", body.name, "!")
			DETECTED = true
			detectedUnit = body
			#detectedUnits.append(body)


func _on_Timer_timeout():
	if DIGGING_PROGRESS < DIGGING_MAX:
		DIGGING_PROGRESS += 1
		if $dot.visible == false:
			$dot.visible = true
		elif $dot2.visible == false:
			$dot2.visible = true
		elif $dot3.visible == false:
			$dot3.visible = true


func _on_Detection_area_entered(area):
	if area.get_parent().is_in_group("Unit") && ACTIVATED:
		if area.get_parent().team != team:
			print (name, " has detected unit ", area.get_parent().name, "!")
			DETECTED = true
			detectedUnit = area.get_parent()
			#detectedUnits.append(body)
