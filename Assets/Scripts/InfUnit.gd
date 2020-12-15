extends KinematicBody2D



var HP = 3
var attack = 3

var defense = 3
var baseDefense = 3

var detectionRange = 300
var baseDetectionRange = 300

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

var TRACKING = false
var trackingProgress = 0
var trackingSpeed = 0.005

const UnitClass = preload("res://Assets/Classes/Unit.gd")
var myUnit: UnitClass


var retreating = false
var retreatingModifier = 1.5

var avoidWeight = 0.5
var idling = false


func retreat():
	$RetreatingArrows.visible = true
	retreating = true
	speed = speed * retreatingModifier

func stopRetreat():
	$RetreatingArrows.visible = false
	retreating = false
	speed = baseSpeed



func saveMe():
	var type = getType()
	
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


func getType() -> String:
	var type
	if isVehicle:
		type = "Veh"
	elif isArt:
		type = "Art"
	else:
		type = "Inf"
	return type

func getBattleType() -> String:
	var type
	if isVehicle:
		type = "veh"
	elif isArt:
		#if distanceToClosest() < 100:
		#	type = "art_off_guard"
		if DUGIN:
			type = "art_cannon"
		else:
			type = "art_off_guard"
	else:
		type = "Inf"
	return type


func distanceToClosest():
	if detectedUnits.size() > 0:
		var closest = detectedUnits[0]
		var uGP
		var cGP = closest.global_position.distance_to(self.global_position)
		for unit in detectedUnits:
			if unit.team != team:
				uGP = unit.global_position.distance_to(self.global_position)
				if uGP < cGP:
					closest = unit
					cGP = closest.global_position.distance_to(self.global_position)
		print ("Closest Unit Distance:" , cGP)
		return cGP
	return null

# return InfUnit
func getClosestUnit(unitList):
	if detectedUnits.size() > 0:
		var closest = detectedUnits[0]
		var uGP
		var cGP = closest.global_position.distance_to(self.global_position)
		for unit in detectedUnits:
			if unit.team != team:
				uGP = unit.global_position.distance_to(self.global_position)
				if uGP < cGP:
					closest = unit
					cGP = closest.global_position.distance_to(self.global_position)
		print ("Closest Unit:" , closest)
		return closest
	return null


func setUnit(newUnit):
	print ("Setunit called!")
	myUnit = newUnit
	HP = myUnit.stats["HP"]
	attack = myUnit.stats["Strength"]


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
	
	if myUnit == null:
		myUnit = UnitClass.new("DSADASDS", getType())
	
	$Line2D.end_cap_mode = 2
	$Line2D.modulate = Color(0,0.5,0,1)

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


func select():
	#print ("Unit ", name, " selected!")
	SELECTED = true

func deselect():
	#print ("Deselected Unit ", name)
	SELECTED = false


func _process(delta):
	$Name.text = myUnit.name + " " + String(HP)
	#print (myUnit)
	
	if !DEAD:
		
		$HPBar
		
		if TRACKING:
			#print ("TRACKING!!!", detectedUnits)
			drawLines()
		
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
		elif retreating:
			pass
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
				detectionRange = 2000
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
		
		if !PAUSED:
			
			if team != 1 && getType() == "Art":
				if detectionRange != round(baseDetectionRange * 0.5):
					#print ("stopped moving!")
					DIGGING_IN = true
			
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
		
		
		if idling:
			var dir = avoid() * avoidWeight
			dir *= speed
			move_and_collide(dir * delta)
			if avoid() == Vector2.ZERO:
				moving = false
				idling = false
		elif moving == true && PAUSED == false && idling == false:
			
			if getType() == "Art" && team != 1:
				return
			
			$target.global_position = dest
			#$target.visible = true
			var dir = dest - self.global_position
			dir = dir.normalized()
			dir += avoid() * avoidWeight
			dir = dir.normalized()
			dir = dir * speed
			move_and_collide(dir * delta)
			if self.global_position.distance_to(dest) < 5:
				idling = true
		elif moving == true && PAUSED == true:
			$target.global_position = dest
			#$target.visible = true
		else:
			$target.visible = false
		
		if SELECTED:
			$box.visible = true
			#print (detectedUnits)
		else:
			$box.visible = false
			
		
		myUnit.stats["Strength"] = attack
	


var foo = {}

func debugPrint(line: String):
	if foo.has(line) == false:
		foo[line] = 0
	else:
		for key in foo.keys():
			if foo[key] >= 30:
				print (key)
				foo[key] = 0
			else:
				foo[key] += 1


func avoid():
	
	# Calculates avoidance vector based on nearby units.
	var result = Vector2.ZERO
	var neighbors = $BumpSpace.get_overlapping_bodies()
	for n in neighbors:
		if n != self:
			result += n.global_position.direction_to(global_position)
	if result != Vector2.ZERO:
		result /= neighbors.size()
		#print ("Works ", result.normalized())
		return result.normalized()
	else:
		#print ("Done.")
		return result


func manualDetectionUpdate():
	var detection = $Detection/CollisionShape2D.shape.radius
	trackingProgress = 0
	detectedUnits = []
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit.team != team:
			if unit.global_position.distance_to(self.global_position) <= detection:
				#print (name, " has MANUALLY detected unit ", unit.name, "!")
				detectedUnits.append(unit)	
	if detectedUnits.size() > 0:
		detectedUnit = getClosestUnit(detectedUnits)
		TRACKING = true


func _on_Detection_body_entered(body):
	if body.is_in_group("Unit") && ACTIVATED:
		if body.team != team:
			#print (name, " has detected unit body ", body.name, "!")
			detectedUnits.append(body)
			if detectedUnits.size() > 0:
				detectedUnit = getClosestUnit(detectedUnits)
			#if team == 1:
			TRACKING = true

func _on_Detection_body_exited(body):
	if body.is_in_group("Unit") && ACTIVATED:
		if body.team != team:
			if detectedUnits.has(body):
				detectedUnits.remove(detectedUnits.find(body))
			if detectedUnit == body:
				detectedUnit = null
			$Line2D.modulate = Color(0,0.5,0,1)
			drawLines()
	if detectedUnits.size() == 0:
		TRACKING = false
		trackingProgress = 0


# Give each line it's own tracking progress!!!
func drawLines():
	$Line2D.clear_points()
	if detectedUnits.size() > 0:# && PAUSED == false
		if !PAUSED:
			trackingProgress += trackingSpeed
		$Line2D.add_point(Vector2(0,0))
		$Line2D.modulate = Color(trackingProgress, 0.5 - (trackingProgress * 0.5), 0, 1)
		var maybe = Vector2()
		for unit in detectedUnits:
			maybe = unit.global_position - global_position
			$Line2D.add_point(maybe)
			$Line2D.add_point(Vector2(0,0))
		
		if trackingProgress >= 0.7:
			DETECTED = true
			detectedUnit = detectedUnits[0]
			#detectedUnit = getClosestUnit()



func _on_Timer_timeout():
	if DIGGING_PROGRESS < DIGGING_MAX:
		DIGGING_PROGRESS += 1
		if $dot.visible == false:
			$dot.visible = true
		elif $dot2.visible == false:
			$dot2.visible = true
		elif $dot3.visible == false:
			$dot3.visible = true












"""
func _on_Detection_area_entered(area):
	if area.get_parent().is_in_group("Unit") && ACTIVATED:
		if area.get_parent().team != team:
			print (name, " has detected unit area ", area.get_parent().name, "!")
			print ("\t", area.name)
			DETECTED = true
			detectedUnit = area.get_parent()
			#detectedUnits.append(body)
"""



