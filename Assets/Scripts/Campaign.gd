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


export(NodePath) var camPath
export(NodePath) var loc1
export(NodePath) var loc2
export(NodePath) var loc3

const ray_length = 1000

var moving = false

var loading = false

var destName



func _ready():
	
	
	
	var global = get_node("/root/Global") 
	
	global.unitTags = []
	
	beat1 = global.beat1
	beat2 = global.beat2
	beat3 = global.beat3
	
	
	if beat1 == false:
		get_node(loc1).get_node("flagpole").get_surface_material(0).albedo_texture = load("res://Assets/Materials/BadFlagpoleTextured.png")
	if beat2 == false:
		get_node(loc2).get_node("flagpole").get_surface_material(0).albedo_texture = load("res://Assets/Materials/BadFlagpoleTextured.png")
	if beat3 == false:
		get_node(loc3).get_node("flagpole").get_surface_material(0).albedo_texture = load("res://Assets/Materials/BadFlagpoleTextured.png")

	
	global.kickedBattle = false
	global.kickedEngagement = false

func getDesc(locationName):
	if locationName == "Entry Point":
		return "Begin the excursion into enemy territory.\nRemember to conserve units, new ones are hard to come by."
	elif locationName == "Ambush":
		return "INEVITABLE, YET STILL UNEXPECTED."
	elif locationName == "Siege":
		return "THIS IS IT.\nFINISH THE FIGHT."
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
	loading = false
	if destName == "Entry Point":
		loading = true
		#get_tree().change_scene("res://Scenes/Level1.tscn")
	elif destName == "Ambush":
		loading = true
		#get_tree().change_scene("res://Scenes/Level2.tscn")
	elif destName == "Siege":
		loading = true
		#get_tree().change_scene("res://Scenes/Level3.tscn")
	if loading:
		$CanvasLayer/LoadingScreen.rise()



func _on_LoadingScreen_animation_finished():
	print ("DONE")
	if destName == "Entry Point":
		get_tree().change_scene("res://Scenes/Level1.tscn")
	elif destName == "Ambush":
		get_tree().change_scene("res://Scenes/Level2.tscn")
	elif destName == "Siege":
		get_tree().change_scene("res://Scenes/Level3.tscn")
