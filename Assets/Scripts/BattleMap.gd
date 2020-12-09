extends Node2D




export (int) var playerTeam = 1
export (Color) var playerColor

export (int) var badTeam = 2
export (Color) var badColor



const UnitClass = preload("res://Assets/Classes/Unit.gd")


var swording = false

var SELECTING = false
var PAUSED = true

var childSelected

var alliedName
var alliedDice
var alliedHP
var defenderAllied
var enemyName
var enemyDice
var enemyHP
var defenderEnemy

var zoomPos
var DETECTED = false

var alliedInfUnits

var alliedTag
var enemyTag

var aUnit
var eUnit


var begun = false

var unitTags = []

var deployingBox = false
var retractingBox = false

export (NodePath) var dicebox

var ENGAGED = false

func _ready():
	
	# lol im keeping this
	print ("WHAT IS GOING ON")
	
	pauseGame()
	#begin()
	if get_node("/root/Global").init:
		for unit in get_tree().get_nodes_in_group("Unit"):
			unit.queue_free()
		$BuyScreen.queue_free()
		$PlacementBox.queue_free()

	#if get_node("/root/Global").unitNames.size() > 0:
		#loadGlobal()

	#begin()


func begin():
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit.ACTIVATED == false:
			unit.ACTIVATED = true
	for child in get_children():
		if child.is_in_group("Unit"):
			if child.team == playerTeam:
				child.paint(playerColor)
			elif child.team == badTeam:
				child.paint(badColor)
	begun = true










func loadDice():
	if ENGAGED == false:
		deployBox()
		$CanvasLayer/DiceBox2D.fight(aUnit, eUnit)
		ENGAGED = true

func deployBox():
	deployingBox = true
	retractingBox = false

func retractBox():
	retractingBox = true
	deployingBox = false



func _process(delta):
	
	
	if deployingBox:
		#print ("DEPLOY")
		var box = get_node(dicebox)
		box.position.y = lerp(box.position.y, 0, 0.05)
		if box.position.y >= -0.01:
			box.position.y = 0
			deployingBox = false
	if retractingBox:
		#print ("RETRACT")
		var box = get_node(dicebox)
		box.position.y = lerp(box.position.y, -800, 0.05)
		if box.position.y + 800 <= 0.01:
			box.position.y = -800
			retractingBox = false
	
	
	if unitTags == []:
		for unit in get_tree().get_nodes_in_group("Unit"):
			unitTags.append(unit.tag)
		if get_node("/root/Global").unitTags == []:
			get_node("/root/Global").unitTags = unitTags

	if begun:
		
		if DETECTED:
			$Camera2D.global_position = lerp ($Camera2D.global_position, zoomPos, 0.1)
			#$Camera2D.zoom = lerp ($Camera2D.zoom, Vector2(1,1), 0.05)
		
		for unit in get_tree().get_nodes_in_group("Unit"):
			if unit.team == badTeam:
				var destUnit = unit.getNearest(get_tree().get_nodes_in_group("Unit"))
				if destUnit != null:
					var dest = unit.getNearest(get_tree().get_nodes_in_group("Unit")).global_position
					unit.dest = dest
					unit.moving = true
		
		if checkDetection():
			var alliedUnit 
			var enemyUnit
			# INF UNIT
			var unit = checkDetection()
			
			# check if detected bodies has stuff in it
			if unit.detectedUnits.size() > 0:
				# if so, present it somehow to Global
				var global = get_node("/root/Global")
				global.enemiesEngaged = unit.detectedUnits
				global.detectorUnit = unit
				# then in Spatial if there's multiple enemies, fight them one at a time until
				# they're all gone
				
				aUnit = unit
				eUnit = unit.getClosestUnit(unit.detectedUnits)

			else:
				if unit.team == playerTeam:
					alliedUnit = unit
					enemyUnit = unit.detectedUnit
				else:
					alliedUnit = unit.detectedUnit
					enemyUnit = unit
				
				aUnit = alliedUnit
				eUnit = enemyUnit

			if $zoomTime.is_stopped() && !ENGAGED:
				print ("Zoom time started!")
				$zoomTime.start()
				

			pauseGame()
			zoomPos = unit.global_position
			DETECTED = true
			if swording == false:
				swording = true
				var instance = load("res://Scenes/SwordCrossing.tscn").instance()
				add_child(instance)
				var instancePos = (zoomPos + unit.global_position) * 0.5
				instancePos.y += 50
				instance.global_position = instancePos


func clearUnitValues():
	for unit in get_tree().get_nodes_in_group("Unit"):
		unit.DETECTED = false
		unit.TRACKING = false


func checkDetection():# -> UnitClass:
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit.DETECTED:
			return unit#.myUnit
	return null
				
			


func pauseGame():
	$CanvasLayer/Paused.visible = true
	PAUSED = true
	for unit in get_tree().get_nodes_in_group("Unit"):
		unit.PAUSED = PAUSED


func unpauseGame():
	$CanvasLayer/Paused.visible = false
	PAUSED = false
	for unit in get_tree().get_nodes_in_group("Unit"):
		unit.PAUSED = PAUSED


func _input(event):
		
	if event.is_action_pressed("Space"):
		if begun && !has_node("BuyScreen"):
			if PAUSED:
				unpauseGame()
			else:
				pauseGame()
		
		
		
	if event.is_action_pressed("click"):
		
		# If you don't haave anyone selected
		if SELECTING == false:
			for child in get_children():
				if child.is_in_group("Unit"):
					if child.MOUSE_OVER == true:
						if child.team == playerTeam:
							childSelected = child
							child.SELECTED = true
							SELECTING = true
							$CanvasLayer/selecting.visible = true
							return

		
		# If you DO have someone selected
		else:
			$CanvasLayer/selecting.visible = false
			childSelected.SELECTED = false
			SELECTING = false
			for child in get_children():
				if child.is_in_group("Unit"):
					if child.MOUSE_OVER == true:
						return
			
			# If you didn't click anyone it'll just move there
			childSelected.dest = get_global_mouse_position()
			childSelected.moving = true
			




func _on_zoomTime_timeout():
	#saveGlobal()
	print ("LOADING DICE")
	loadDice()


### THIS IS THE DUMBEST METHOD OF DOING THIS
var twiced = false
func _on_lossTime_timeout():
	
	#print ("loss time")
	
	var alliedInfUnits = 0
	for localUnit in get_tree().get_nodes_in_group("Unit"):
		if localUnit.is_in_group("Unit") && !localUnit.is_in_group("vehicle"):
			if localUnit.team == playerTeam:
				alliedInfUnits += 1
	
	#print ("allied units: ", alliedInfUnits)
	if alliedInfUnits <= 0:
		#var global = get_node("/root/Global")
		#if global.infCount == 0 && global.vehCount == 0 && global.artCount == 0:
		if has_node("BuyScreen") == false && has_node("PlacementBox") == false:
			if twiced:
				#print ("GAME OVER")
				get_tree().change_scene("res://Scenes/Title.tscn")
			else:
				twiced = true
		else:
			pass#print ("ah u got buy screen its ok")
	else:
		twiced = false
