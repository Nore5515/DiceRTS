extends TextureRect


var unit
export (NodePath) var plopParent


func init(unitAssignment, newParent):
	unit = unitAssignment
	plopParent = newParent


func _on_Button_pressed():
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
