extends Spatial


const level1Pos = Vector3(-4.9, 0.05, -1.7)
const level2Pos = Vector3(3.2,0.05,-0.93)
const level3Pos = Vector3(7.89, 0.05, -0.48)

#var halfway
#var reachedHalfway = false

var moving1 = false
var moving2 = false
var moving3 = false

var dest


func _ready():
	var global = get_node("/root/Global") 
	
	global.unitTags = []
	
	#get_node("/root/Global").unitDead = []
	if global.level == 1:
		moving1 = true
		dest = level1Pos
	elif global.level == 2:
		moving2 = true
		dest = level2Pos
		$pawn.translation = level2Pos
	$Tween.interpolate_property($pawn, "translation", $pawn.translation, dest, 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()
	
	global.kickedBattle = false
	global.kickedEngagement = false


func _on_Tween_tween_all_completed():
	$Timer.start()
	$Timer.start()


func _on_Timer_timeout():
	var global = get_node("/root/Global") 
	if global.level == 1:
		get_tree().change_scene("res://Scenes/Level1.tscn")
	elif global.level == 2:
		get_tree().change_scene("res://Scenes/Level2.tscn")


func _input(event):
	if event is InputEventKey and event.pressed:
		_on_Timer_timeout()
	if event is InputEventMouseButton and event.pressed:
		_on_Timer_timeout()
		
	
