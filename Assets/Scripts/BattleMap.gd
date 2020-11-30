extends Node2D




export (int) var playerTeam = 1
export (Color) var playerColor

export (int) var badTeam = 2
export (Color) var badColor


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

var begun = false

var unitTags = []


func _ready():
	
	print ("WHAT IS GOING ON")
	
	pauseGame()
	#begin()
	if get_node("/root/Global").init:
		for unit in get_tree().get_nodes_in_group("Unit"):
			unit.queue_free()
		$BuyScreen.queue_free()
		$PlacementBox.queue_free()

	if get_node("/root/Global").unitNames.size() > 0:
		loadGlobal()


	
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


func loadGlobal():
	
	var global = get_node("/root/Global")
	
	for unit in global.allUnits:
		print ("loading unit: ", unit)
		var instance
		if unit["type"] == "Inf":
			instance = load("res://Scenes/InfUnit.tscn").instance()
			instance.loadMe(unit)
		elif unit["type"] == "Veh":
			instance = load("res://Scenes/VehicalUnit.tscn").instance()
			instance.loadMe(unit)
		elif unit["type"] == "Art":
			instance = load("res://Scenes/ArtUnit.tscn").instance()
			instance.loadMe(unit)
		print (instance)
		add_child(instance)
	
	for localUnit in get_tree().get_nodes_in_group("Unit"):
		localUnit.ACTIVATED = true
		localUnit.PAUSED = true
		
		if localUnit.tag == global.alliedTag:
			localUnit.HP = global.alliedHP
		elif localUnit.tag == global.enemyTag:
			localUnit.HP = global.enemyHP
	
	for corpseData in global.corpses:
		var instance = load("res://Scenes/Corpse.tscn").instance()
		instance.loadCorpse(corpseData)
		add_child(instance)
	
	#### DEAD STUFF
	var stupider = 0
	for localUnit in get_tree().get_nodes_in_group("Unit"):
		if localUnit.HP <= 0:
			var isInf = false
			var isVeh = false
			var isArt = false
			if localUnit.saveMe()["type"] == "Inf":
				isInf = true
			if localUnit.saveMe()["type"] == "Veh":
				isVeh = true
			if localUnit.saveMe()["type"] == "Art":
				isArt = true
			var instance = load("res://Scenes/Corpse.tscn").instance()
			instance.setInf(isInf, isVeh, isArt)
			instance.global_position = localUnit.global_position
			add_child(instance)
			global.unitTags.erase(localUnit.tag)
			print ("goodbye")
			localUnit.queue_free()
		stupider += 1



	#Fortifying all units that are in the Fortify list, then wiping it clean
	for localUnit in get_tree().get_nodes_in_group("Unit"):
		if global.unitsFortified.has(localUnit.name):
			localUnit.DIGGING_PROGRESS = localUnit.DIGGING_MAX
			localUnit.DIGGING_IN = true
			localUnit.DUGIN = true
	global.unitsFortified = []
			
	print ("done loading!")
	begin()



func saveGlobal():
	var global = get_node("/root/Global")
	global.unitNames = []
	global.unitPos = []
	global.unitHP = []
	global.unitSlowed = []
	global.unitMegaSlowed = []
	global.alliedName = alliedName
	global.alliedDice = alliedDice
	global.alliedHP = alliedHP
	global.defenderAllied = defenderAllied
	global.enemyName = enemyName
	global.enemyDice = enemyDice
	global.enemyHP = enemyHP
	global.defenderEnemy = defenderEnemy
	
	global.init = true
	
	global.alliedTag = alliedTag
	global.enemyTag = enemyTag
	
	global.allUnits = []
	for unit in get_tree().get_nodes_in_group("Unit"):
		global.allUnits.append(unit.saveMe())
	
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit.team == 1:
			global.boughtUnits.append(unit.saveMe())
			#unit.queue_free()
	
	global.corpses = []
	for corpse in get_tree().get_nodes_in_group("Corpse"):
		global.corpses.append(corpse.save())
	
	for unit in get_tree().get_nodes_in_group("Unit"):
		global.unitNames.append(unit.name)
		global.unitPos.append(unit.global_position)
		global.unitHP.append(unit.HP)
		if unit.SLOWED:
			global.unitSlowed.append(unit)
		elif unit.MEGASLOWED:
			global.unitMegaSlowed.append(unit)
		
		if unit.DUGIN:
			global.unitsFortified.append(unit.name)
		#if unit.HP <= 0:
			#if global.unitDead.has(unit) == false:
				#global.unitDead.append(unit)
				#global.deadSpots.append(unit.global_position)



func loadDice():
	saveGlobal()
	get_tree().change_scene("res://Scenes/Spatial.tscn")




func _process(delta):
	
	
	if unitTags == []:
		for unit in get_tree().get_nodes_in_group("Unit"):
			unitTags.append(unit.tag)
		if get_node("/root/Global").unitTags == []:
			get_node("/root/Global").unitTags = unitTags

	if begun:
		
		
		if DETECTED:
			$Camera2D.global_position = lerp ($Camera2D.global_position, zoomPos, 0.1)
			$Camera2D.zoom = lerp ($Camera2D.zoom, Vector2(1,1), 0.05)
		
		for unit in get_tree().get_nodes_in_group("Unit"):
			if unit.team == badTeam:
				var destUnit = unit.getNearest(get_tree().get_nodes_in_group("Unit"))
				if destUnit != null:
					var dest = unit.getNearest(get_tree().get_nodes_in_group("Unit")).global_position
					unit.dest = dest
					unit.moving = true
	
		for unit in get_tree().get_nodes_in_group("Unit"):
			if unit.DETECTED:
				var alliedUnit 
				var enemyUnit
				
				# check if detected bodies has stuff in it
				if unit.detectedUnits.size() > 0:
					# if so, present it somehow to Global
					var global = get_node("/root/Global")
					global.enemiesEngaged = unit.detectedUnits
					global.detectorUnit = unit
					# then in Spatial if there's multiple enemies, fight them one at a time until
					# they're all gone
				else:
					if unit.team == playerTeam:
						alliedUnit = unit
						enemyUnit = unit.detectedUnit
					else:
						alliedUnit = unit.detectedUnit
						enemyUnit = unit
		
					if alliedUnit.DUGIN:
						defenderAllied = true
					if enemyUnit.DUGIN:
						defenderEnemy = true
		
					alliedName = alliedUnit.name
					alliedDice = alliedUnit.attack
					alliedHP = alliedUnit.HP
					enemyName = enemyUnit.name
					enemyDice = enemyUnit.attack
					enemyHP = enemyUnit.HP
					
					alliedTag = alliedUnit.tag
					enemyTag = enemyUnit.tag
	
				if $zoomTime.is_stopped():
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
	saveGlobal()
	loadDice()


func _on_lossTime_timeout():

	var alliedInfUnits = 0
	for localUnit in get_tree().get_nodes_in_group("Unit"):
		if localUnit.is_in_group("Unit") && !localUnit.is_in_group("vehicle"):
			if localUnit.team == playerTeam:
				alliedInfUnits += 1
	
	if alliedInfUnits <= 0:
		var global = get_node("/root/Global")
		if global.infCount == 0 && global.vehCount == 0 && global.artCount == 0:
			if get_node("/root/Global").boughtUnits.size() <= 0:
				get_tree().change_scene("res://Scenes/Title.tscn")
