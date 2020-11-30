extends Node2D


var over = false
var global

var selecting = ""

var boughtTags = []

func makeVisible():
	for child in $CanvasLayer.get_children():
		child.visible = true


func _ready():
	global = get_node("/root/Global")
	cleanCursor()
	for child in $CanvasLayer.get_children():
		child.visible = false


func _process(delta):
	
	if global.infCount == 0 && global.vehCount == 0 && global.artCount == 0:
		$CanvasLayer/Button.visible = true
	
	$CanvasLayer/infCount.text = String(global.infCount)
	$CanvasLayer/vehCount.text = String(global.vehCount)
	$CanvasLayer/artCount.text = String(global.artCount)
	
	$Cursor.global_position = get_global_mouse_position()
	
	if selecting == "":
		cleanCursor()
	elif selecting == "inf":
		cleanCursor()
		$Cursor/infCursor.visible = true
	elif selecting == "veh":
		cleanCursor()
		$Cursor/vehCursor.visible = true
	elif selecting == "art":
		cleanCursor()
		$Cursor/artCursor.visible = true


func cleanCursor():
	if $Cursor/infCursor.visible == true:
		$Cursor/infCursor.visible = false
	if $Cursor/vehCursor.visible == true:
		$Cursor/vehCursor.visible = false
	if $Cursor/artCursor.visible == true:
		$Cursor/artCursor.visible = false


func _on_Area2D_mouse_entered():
	over = true

func _on_Area2D_mouse_exited():
	over = false


func _on_infButton_pressed():
	selecting = "inf"
func _on_vehButton_pressed():
	selecting = "veh"
func _on_artButton_pressed():
	selecting = "art"
	
func _input(event):
	if event.is_action_pressed("esc"):
		selecting = ""
	
	elif event.is_action_pressed("click"):
		if over:
			if selecting == "inf":
				if global.infCount > 0:	
					var instance = load("res://Scenes/InfUnit.tscn").instance()
					instance.team = 1
					instance.global_position = $Cursor.global_position
					get_parent().add_child(instance)
					global.infCount -= 1
					instance.PAUSED = true
					if boughtTags.has(instance.tag) == false:
						boughtTags.append(instance.tag)
			elif selecting == "veh":
				if global.vehCount > 0:
					var instance = load("res://Scenes/VehicalUnit.tscn").instance()
					instance.team = 1
					instance.global_position = $Cursor.global_position
					get_parent().add_child(instance)
					global.vehCount -= 1
					instance.PAUSED = true
					if boughtTags.has(instance.tag) == false:
						boughtTags.append(instance.tag)
			elif selecting == "art":
				if global.artCount > 0:
					var instance = load("res://Scenes/ArtUnit.tscn").instance()
					instance.team = 1
					instance.global_position = $Cursor.global_position
					get_parent().add_child(instance)
					global.artCount -= 1
					instance.PAUSED = true
					if boughtTags.has(instance.tag) == false:
						boughtTags.append(instance.tag)




func _on_Button_pressed():
	for tag in boughtTags:
		global.unitTags.append(tag)
	get_parent().begin()
	queue_free()
