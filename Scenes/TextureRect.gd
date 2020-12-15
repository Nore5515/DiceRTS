extends TextureRect


var unit
export (NodePath) var plopParent
var selected = false

func init(unitAssignment, newParent):
	unit = unitAssignment
	if newParent == null:
		#print ("new parent is null, so we're setting plopParent to null as well")
		plopParent = null
	else:
		plopParent = newParent


func _on_Button_pressed():
	if selected:
		selected = false
		$Swords.modulate.a = 0
	else:
		selected = true
		$Swords.modulate.a = 1
		if plopParent != null:
			if get_tree().get_nodes_in_group("bark").size() == 0:
				var instance = load("res://Scenes/bark.tscn").instance()
				instance.init(unit.getBark())
				get_node(plopParent).add_child(instance)
			else:
				for bark in get_tree().get_nodes_in_group("bark"):
					bark.queue_free()
				var instance = load("res://Scenes/bark.tscn").instance()
				instance.init(unit.getBark())
				get_node(plopParent).add_child(instance)
	

	
