extends ScrollContainer


var global
var squad
var unitRef

"""
class Unit:
	var name: String
	var type: String # inf, veh, art
	var HP: int
"""
var baseRectSize

var init = false

func _ready():
	
	baseRectSize = rect_size
	
	global = get_node("/root/Global")
	squad = global.squad
	
	"""
	unitRef = load("res://Assets/Classes/Unit.gd")
	var newUnit = unitRef.new("Howdy", "art")
	newUnit.type = "art"
	squad.append(newUnit)
	
	newUnit = unitRef.new("Nice", "veh")
	newUnit.type = "veh"
	squad.append(newUnit)
	
	newUnit = unitRef.new("Huh", "inf")
	newUnit.type = "inf"
	squad.append(newUnit)
	"""
	

	
func updateStuff():
	for squaddie in $HBoxContainer.get_children():
		squaddie.queue_free()
	squad = global.squad
	init = false


func setup():
	rect_size = Vector2(0,0)
	var instance
	var txt
	for squaddie in squad:
		instance = load("res://Scenes/TextureRect.tscn").instance()
		instance.init(squaddie, self.get_parent().get_node("Control").get_path())
		if squaddie.type == "inf":
			instance.texture = load("res://Assets/Art/inf.png")
		elif squaddie.type == "veh":
			instance.texture = load("res://Assets/Art/vehical.png")
		elif squaddie.type == "art":
			instance.texture = load("res://Assets/Art/artillery.png")
		$HBoxContainer.add_child(instance)
		txt = squaddie.name
		txt += " " + String(squaddie.HP) + "/" + String(squaddie.maxHP)
		instance.get_child(0).text = txt
		instance.get_child(1).text = "Battles: " + String(squaddie.combats)
		instance.rect_min_size = Vector2(129,129)



func _process(delta):
	if !init:
		setup()
		if get_node("HBoxContainer").get_child_count() > 0:
			get_node("HBoxContainer").get_child(0).rect_min_size = Vector2(128,128)
		rect_size = baseRectSize
			
		init = true
		print ("done init!")
	
	if get_tree().get_nodes_in_group("bark").size() == 0:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		if $Timer.is_stopped() == false:
			$Timer.stop()


func _on_Timer_timeout():
	randomize()
	var childSize = get_node("HBoxContainer").get_child_count()
	if childSize > 0:
		var unitToBark = get_node("HBoxContainer").get_child( randi()%(childSize))
		unitToBark._on_Button_pressed()
