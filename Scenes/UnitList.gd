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

var selectedUnits = []
var placedUnits = []

var init = false


func _ready():
	
	baseRectSize = rect_size
	
	global = get_node("/root/Global")
	squad = global.squad
	
	setSquadLocal(global.localSquad)

func healSquad(amount: int):
	for squaddie in squad:
		squaddie.heal(amount)
	updateStuff()

	
func updateStuff():
	#print ("gonna queue_free defered all children in ", $HBoxContainer.get_children())
	for squaddie in $HBoxContainer.get_children():
		squaddie.call_deferred("queue_free")
	#print ("no more init. here's the list: ", $HBoxContainer.get_children())
	init = false

func setSquadGlobal():
	updateStuff()
	squad = global.squad

func setSquadLocal(localSquad):
	#print  ("calling update")
	updateStuff()
	#print ("setting locals to ", localSquad)
	squad = localSquad


func resetSelected():
	updateStuff()
	#print (squad)
	for squaddie in $HBoxContainer.get_children():
		squaddie.selected = false

func setup():
	#print ("Running setup.")
	rect_size = Vector2(0,0)
	var instance
	var txt
	#print ("Gonna instance each squaddie in ", squad)
	for squaddie in squad:
		instance = load("res://Scenes/TextureRect.tscn").instance()
		if self.get_parent().has_node("Control") == false:
			print ("Since there's no bark box, instancing with null as its bark box.")
			instance.init(squaddie, null)
		else:
			#print ("Since there's a bark box, instancing normally.")
			instance.init(squaddie, self.get_parent().get_node("Control").get_path())
		if squaddie.type == "inf":
			instance.texture = load("res://Assets/Art/inf.png")
		elif squaddie.type == "veh":
			instance.texture = load("res://Assets/Art/vehical.png")
		elif squaddie.type == "art":
			instance.texture = load("res://Assets/Art/artillery.png")
		#else:
			#print ("err; invalid type")
		$HBoxContainer.add_child(instance)
		txt = squaddie.name
		txt += " " + String(squaddie.HP) + "/" + String(squaddie.maxHP)
		instance.get_child(0).text = txt
		instance.get_child(1).text = "Battles: " + String(squaddie.combats)
		instance.rect_min_size = Vector2(129,129)
		#print (instance)



func _process(delta):
	#setSquadLocal(global.squad)
	if !init:
		if squad != null:
			if squad.size() > 0:
				setup()
				if get_node("HBoxContainer").get_child_count() > 0:
					get_node("HBoxContainer").get_child(0).rect_min_size = Vector2(128,128)
				rect_size = baseRectSize
					
				init = true
				#print ("done init!")
	
	if get_tree().get_nodes_in_group("bark").size() == 0:
		if $Timer.is_stopped():
			$Timer.start()
	else:
		if $Timer.is_stopped() == false:
			$Timer.stop()
		
	
	selectedUnits = []
	for rect in get_node("HBoxContainer").get_children():
		if rect.selected:
			selectedUnits.append(rect.unit)


func removeFromSquad(removed):
	print ("Checking for removal...")
	if squad.has(removed):
		print ("Removed!")
		squad.remove(squad.find(removed))
	updateStuff()


#func _on_Timer_timeout():
	#randomize()
	#var childSize = get_node("HBoxContainer").get_child_count()
	#if childSize > 0:
	#	var unitToBark = get_node("HBoxContainer").get_child( randi()%(childSize))
	#	unitToBark._on_Button_pressed()
