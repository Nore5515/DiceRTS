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

var selectedUnits = []
var dragging = false
var dragStart


func _ready():
	
	# lol im keeping this
	print ("WHAT IS GOING ON")
	
	print ("Setting the scroll container's local squad to ", get_node("/root/Global").localSquad)
	$PlacementBox/CanvasLayer/ScrollContainer.setSquadLocal(get_node("/root/Global").localSquad)
	
	pauseGame()
	#begin()
	if get_node("/root/Global").init:
		for unit in get_tree().get_nodes_in_group("Unit"):
			unit.queue_free()
		$BuyScreen.queue_free()
		$PlacementBox.queue_free()


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
	$CanvasLayer/DiceBox2D.reset()
	if $CanvasLayer/DiceBox2D.fight(aUnit, eUnit) == true:
		deployBox()
		ENGAGED = true
		SELECTING = false
		#print (get_tree().get_nodes_in_group("Unit"))
	else:
		print ("get outta here")
		ENGAGED = false
		DETECTED = false
		retractBox()
		resetSword()
		call_deferred("clearUnitValues")
		$zoomTime.stop()


func deployBox():
	deployingBox = true
	retractingBox = false

func retractBox():
	retractingBox = true
	deployingBox = false


func processDeploy():
	var box = get_node(dicebox)
	box.position.y = lerp(box.position.y, 0, 0.05)
	if box.position.y >= -0.01:
		box.position.y = 0
		deployingBox = false
func processRetract():
	# ????
	#resetSword()
	var box = get_node(dicebox)
	box.position.y = lerp(box.position.y, -800, 0.05)
	if box.position.y + 800 <= 0.01:
		box.position.y = -800
		retractingBox = false


func ifDetected():
	$Camera2D.global_position = lerp ($Camera2D.global_position, zoomPos, 0.1)
	#$Camera2D.zoom = lerp ($Camera2D.zoom, Vector2(1,1), 0.05)


func moveEnemies():
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit.team == badTeam:
			if unit.getType() != "Art":
				var destUnit = unit.getNearest(get_tree().get_nodes_in_group("Unit"))
				if destUnit != null:
					var dest = unit.getNearest(get_tree().get_nodes_in_group("Unit")).global_position
					unit.dest = dest
					unit.moving = true
			else:
				unit.moving = false 



func endFight():
	ENGAGED = false
	DETECTED = false
	retractBox()
	resetSword()
	clearUnitValues()
	$zoomTime.stop()



func _process(delta):
	
	if deployingBox:
		processDeploy()
	if retractingBox:
		processRetract()
	
	"""if dragging:
		$Drawings.draw_rect(Rect2(dragStart, get_global_mouse_position() - dragStart),
				Color(.5, .5, .5), true)
		$Drawings.update()"""
	
	if begun:
		
		if DETECTED:
			ifDetected()
		moveEnemies()
	
		
		if ENGAGED == false:
			if checkDetection() && checkDetection().DEAD == false:
				print ("DETECTED!")
				ENGAGED = true
				var unit = checkDetection()
				unit.manualDetectionUpdate()
				if unit.team == playerTeam:
					aUnit = unit
					eUnit = unit.getClosestUnit(unit.detectedUnits)
				else:
					aUnit = unit.getClosestUnit(unit.detectedUnits)
					eUnit = unit
				print ("Zoom time started!")
				#print ("Allied Unit: ", aUnit, "/", aUnit.team)
				#print ("Enemy Unit: ", eUnit, "/", eUnit.team)
				if eUnit == null || aUnit == null:
					endFight()
				$zoomTime.start()
				pauseGame()
				zoomPos = unit.global_position
				DETECTED = true
				if swording == false:
					makeSwords(unit.global_position)



func makeSwords(swordPos: Vector2):
	print ("Making swords!")
	if has_node("Swords"):
		print ("You already have swords, get outta here!")
	else:
		swording = true
		var instance = load("res://Scenes/SwordCrossing.tscn").instance()
		add_child(instance)
		var instancePos = (zoomPos + swordPos) * 0.5
		instancePos.y += 50
		instance.global_position = instancePos
		instance.name = "Swords"
		print ("Made swords!")


func clearUnitValues():
	for unit in get_tree().get_nodes_in_group("Unit"):
		unit.DETECTED = false
		unit.TRACKING = false
		unit.manualDetectionUpdate()
		unit.drawLines()


func checkDetection():# -> UnitClass:
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit.DETECTED:
			print ("Unit ", unit, " (", unit.name, ") is positive for Detection.")
			return unit#.myUnit
	return null


func resetSword():
	if has_node("Swords"):
		print ("Swords removed.")
		get_node("Swords").call_deferred("queue_free")
		swording = false


func resetArtilleryFort():
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit.getType() == "Art":
			unit.DIGGING_IN = false


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
		#unit.manualDetectionUpdate()

	

func updateSelection():
	var foo = "Updating Selection."
	selectedUnits = []
	for unit in get_tree().get_nodes_in_group("Unit"):
		unit.deselect()
		if unit.team == playerTeam:
			#print ("Checking if unit ", unit, " is in box...")
			if $SelectionBox.isShapeInBox(unit):
				print ("Unit was in box!")
				unit.select()
				#unit.SELECTED = $SelectionBox.isShapeInBox(unit)
				selectedUnits.append(unit)
	if selectedUnits.size() > 0:
		SELECTING = true
		foo += " || At least one unit was selected."
	#print (foo)



func _input(event):
		
	if event.is_action_pressed("Space") && ENGAGED == false && $zoomTime.time_left == 0:
		if begun && !has_node("BuyScreen"):
			if PAUSED:
				unpauseGame()
			else:
				pauseGame()
	
	
	#if event.is_action_released("click"):
		#updateSelection()

	#if event.is_action_pressed("click") && ENGAGED == false:
	if event.is_action_pressed("rClick") && ENGAGED == false:
		
		#print ("Clicking while units are selected!")
		$CanvasLayer/selecting.visible = false
		#if childSelected:
			#childSelected.SELECTED = false
			#childSelected.stopRetreat()
		
		# If you didn't click anyone it'll just move there
		for unit in selectedUnits:
			unit.dest = get_global_mouse_position()
			unit.moving = true
			unit.stopRetreat()
			unit.deselect()
	
			
		SELECTING = false
		selectedUnits = []
		

		if doubling == false:
			doubleClickDetection()
		else:
			if childSelected:
				childSelected.retreat()
			#if childSelected:
				#childSelected.retreat()


func _on_zoomTime_timeout():
	#saveGlobal()
	print ("zoomTime timed out, LOADING DICE")
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


# UNNECESSArY ?
func _on_WaitTime_timeout():
	print ("Wait Time ended.")
	print ($zoomTime, $zoomTime.time_left, $zoomTime.wait_time)
	$zoomTime.stop()
	$zoomTime.wait_time = 0.1
	$zoomTime.start()
	begun = true
	

var doubling = false

func doubleClickDetection():
	doubling = true
	$DoubleClick.start()

func _on_DoubleClick_timeout():
	doubling = false
