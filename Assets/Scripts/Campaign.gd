extends Spatial


const level1Pos = Vector3(-4.9, 0.05, -1.7)
const level2Pos = Vector3(3.2,0.05,-0.93)
const level3Pos = Vector3(7.89, 0.05, -0.48)

#var halfway
#var reachedHalfway = false

var moving1 = false
var moving2 = false
var moving3 = false


var beat1 = false
var beat2 = false
var beat3 = false
var beatOptional = false
var beatCheckpoint = false


export(NodePath) var camPath
export(NodePath) var loc1
export(NodePath) var loc2
export(NodePath) var loc3

const ray_length = 1000

var moving = false

var loading = false

var destName

var rdyToGo = false

func _ready():
	
	#$CanvasLayer/LoadingScreen.sink()
	
	var global = get_node("/root/Global") 
	"""
	if global.localSquad.size() > 0:
		print ("\t", global.localSquad, " vs ", global.squad)
		for squaddie in global.localSquad:
			global.squad.append(squaddie)
		global.localSquad = []
		$ScrollBox/ScrollContainer.update()
		print ("\t", global.localSquad, " vs ", global.squad)
	"""
	$ScrollBox/ScrollContainer.setSquadGlobal()
	
	global.unitTags = []
	
	beat1 = global.beat1
	beat2 = global.beat2
	beat3 = global.beat3
	beatOptional = global.beatOptional
	beatCheckpoint = global.beatCheckpoint
	
	setGlobalLevelProgress()
	setLocalLevelProgress()
	
	if beat1 == false:
		get_node(loc1).get_node("flagpole").get_surface_material(0).albedo_texture = load("res://Assets/Materials/BadFlagpoleTextured.png")
	if beat2 == false:
		get_node(loc2).get_node("flagpole").get_surface_material(0).albedo_texture = load("res://Assets/Materials/BadFlagpoleTextured.png")
	if beat3 == false:
		get_node(loc3).get_node("flagpole").get_surface_material(0).albedo_texture = load("res://Assets/Materials/BadFlagpoleTextured.png")
	if beatOptional == false:
		$Cache.get_node("flagpole").get_surface_material(0).albedo_texture = load("res://Assets/Materials/BadFlagpoleTextured.png")
	if beatCheckpoint == false:
		$Checkpoint/flagpole.get_surface_material(0).albedo_texture = load("res://Assets/Materials/BadFlagpoleTextured.png")
	
	global.kickedBattle = false
	global.kickedEngagement = false


func _process(delta):
	if $ScrollBox/ScrollContainer.selectedUnits.size() > 0:
		$CanvasLayer/BeginButton.disabled = false
	else:
		$CanvasLayer/BeginButton.disabled = true



func setGlobalLevelProgress():
	var global = get_node("/root/Global") 
	# If you haven't started it yet...
	if global.availableLevels.size() == 0:
		global.availableLevels.append("EntryPoint")
	# This isn't your first time...
	else:
		# So all units in your squad heal 1!
		$ScrollBox/ScrollContainer.healSquad(1)
		# If you've beaten Entry Point, add the next level
		if beat1:
			global.availableLevels.append("Checkpoint")
		if beatCheckpoint:
			global.availableLevels.append("Ambush")
			global.availableLevels.append("Cache")
		# So on and so forth
		if beat2:
			global.availableLevels.append("Siege")
		if beat3:
			print ("Beat all!")



func setLocalLevelProgress():
	var global = get_node("/root/Global") 
	if global.availableLevels.has("EntryPoint"):
		$EntryPoint/SpotLight2.visible = true
	if global.availableLevels.has("Ambush"):
		$Ambush/SpotLight3.visible = true
	if global.availableLevels.has("Siege"):
		$Siege/SpotLight4.visible = true
	if global.availableLevels.has("Cache"):
		$Cache/SpotLight3.visible = true
	if global.availableLevels.has("Checkpoint"):
		$Checkpoint/SpotLight3.visible = true


func getDesc(locationName):
	if locationName == "EntryPoint":
		return "Begin the excursion into enemy territory.\nRemember to conserve units, new ones are hard to come by."
	elif locationName == "Checkpoint":
		return "Strike while the iron is hot! Punch through their lines!"
	elif locationName == "Ambush":
		return "It was inevitable they would prepare an ambush. Brave the lines, and push to the finish."
	elif locationName == "Siege":
		return "This is it!\nFinish the fight!"
	elif locationName == "Cache":
		return "Although optional, raiding the enemy's supplies could both hinder the enemy and bolster our troops."
	return "err"



func moveToDest(dest):
	$CanvasLayer/BeginButton.visible = false
	$CanvasLayer/LocationTitle.text = ""
	$CanvasLayer/LocationDesc.text = ""
	#$Tween.stop_all()
	if !moving:		
		$Tween.interpolate_property($pawn, "translation", $pawn.translation, dest, 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		moving = true
	else:
		$Tween.interpolate_property($pawn, "translation", $pawn.translation, dest, 2.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$Tween.start()
		moving = true


func _on_Tween_tween_all_completed():
	print("DONE")
	moving = false
	$CanvasLayer/BeginButton.visible = true
	$CanvasLayer/LocationTitle.text = destName
	$CanvasLayer/LocationDesc.text = getDesc(destName)


func _on_Timer_timeout():
	var global = get_node("/root/Global") 
	if global.level == 1:
		get_tree().change_scene("res://Scenes/Level1.tscn")
	elif global.level == 2:
		get_tree().change_scene("res://Scenes/Level2.tscn")


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var camera = get_node(camPath)
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to)
		if result:
			print("Hit at point: ", result.collider.name)
			var dest = result.collider.translation
			destName = result.collider.name
			moveToDest(dest)


func _on_BeginButton_pressed():
	var global = get_node("/root/Global") 
	global.localSquad = [] + $ScrollBox/ScrollContainer.selectedUnits
	for unit in global.squad:
		if global.localSquad.has(unit):
			global.squad.erase(unit)
	loading = false
	if destName == "EntryPoint":
		loading = true
		#get_tree().change_scene("res://Scenes/Level1.tscn")
	elif destName == "Ambush":
		loading = true
		#get_tree().change_scene("res://Scenes/Level2.tscn")
	elif destName == "Siege":
		loading = true
		#get_tree().change_scene("res://Scenes/Level3.tscn")
	elif destName == "Cache":
		loading = true
	elif destName == "Checkpoint":
		loading = true
	if loading:
		$CanvasLayer/LoadingScreen.rise()


func _on_LoadingScreen_animation_finished():
	print ("DONE a")
	var global = get_node("/root/Global") 
	global.localSquad
	if destName == "EntryPoint":
		get_tree().change_scene("res://Scenes/Level1.tscn")
	elif destName == "Ambush":
		get_tree().change_scene("res://Scenes/Ambush.tscn")
	elif destName == "Siege":
		get_tree().change_scene("res://Scenes/Siege.tscn")
	elif destName == "Cache":
		get_tree().change_scene("res://Scenes/Cache.tscn")
	elif destName == "Checkpoint":
		get_tree().change_scene("res://Scenes/Checkpoint.tscn")
