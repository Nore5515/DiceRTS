extends Area2D


export (String) var levelName



func _on_Goal_body_entered(body):
	if body.is_in_group("Unit") && body.is_in_group("vehicle") == false:
		if body.team == 1:
			if levelName == "Level1":
				get_node("/root/Global").beat1 = true
				get_node("/root/Global").budget += 3
			elif levelName == "Level2":
				get_node("/root/Global").beat2 = true
				get_node("/root/Global").budget += 10
			elif levelName == "Level3" || levelName == "Siege":
				get_node("/root/Global").beat3 = true
				get_node("/root/Global").budget += 100
				get_tree().change_scene("res://Scenes/End.tscn")
			elif levelName == "Cache":
				get_node("/root/Global").budget += 0
				get_node("/root/Global").beatOptional = true
			elif levelName == "Checkpoint":
				get_node("/root/Global").budget += 6
				get_node("/root/Global").beatCheckpoint = true
			saveAllAllies()
			overrideGlobal()
			get_tree().change_scene("res://Scenes/Campaign.tscn")


var squad = []
func saveAllAllies():
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit.team == 1:
			squad.append(unit.myUnit)


func overrideGlobal():
	var global = get_node("/root/Global")
	global.localSquad = squad
	
	print (global.squad, " vs ", squad)
	#for squaddie in squad:
	#	global.squad.append(squaddie)

