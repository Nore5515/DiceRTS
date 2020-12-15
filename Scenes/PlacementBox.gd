extends Node2D


var over = false
var global

var selecting = ""

var boughtTags = []


var units = []

#export (NodePath) var scrollContainer
var scrollContainer


func makeVisible():
	for child in $CanvasLayer.get_children():
		child.visible = true


func _ready():
	scrollContainer = $CanvasLayer/ScrollContainer.get_path()
	global = get_node("/root/Global")
	cleanCursor()
	#for child in $CanvasLayer.get_children():
		#child.visible = false
	


func setup():
	for unit in units:
		pass

var selected


func _process(delta):
	
	if $CanvasLayer/ScrollContainer.squad.size() == 0:
		#$CanvasLayer/Button.visible = true
		$CanvasLayer/Button.disabled = false
	else:
		$CanvasLayer/Button.disabled = true
	
	if $CanvasLayer/ScrollContainer.selectedUnits.size() > 0:
		if $CanvasLayer/ScrollContainer.selectedUnits.size() >= 2:
			$CanvasLayer/ScrollContainer.resetSelected()
		else:
			selected = $CanvasLayer/ScrollContainer.selectedUnits[0]
			selecting = selected.type
	else:
		selecting = ""


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
		get_node(scrollContainer).resetSelected()
	
	elif event.is_action_pressed("click"):
		if over:
			if selecting == "inf":
				var instance = load("res://Scenes/InfUnit.tscn").instance() 
				addUnitInstance(instance)
			elif selecting == "veh":
				var instance = load("res://Scenes/VehicalUnit.tscn").instance()
				addUnitInstance(instance)
			elif selecting == "art":
				var instance = load("res://Scenes/ArtUnit.tscn").instance()
				addUnitInstance(instance)


func addUnitInstance(unitInstance):
	var instance = unitInstance
	instance.team = 1
	instance.global_position = $Cursor.global_position
	instance.setUnit(selected)
	get_parent().add_child(instance)
	instance.PAUSED = true
	if boughtTags.has(instance.tag) == false:
		boughtTags.append(instance.tag)
	get_node(scrollContainer).removeFromSquad(selected)
	cleanCursor()
	get_node(scrollContainer).resetSelected()



func _on_Button_pressed():
	for tag in boughtTags:
		global.unitTags.append(tag)
	get_parent().begin()
	queue_free()
