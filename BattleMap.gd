extends Node2D




export (int) var playerTeam = 1
export (Color) var playerColor

var SELECTING = false
var childSelected


func _ready():
	for child in get_children():
		if child.is_in_group("Unit"):
			if child.team == playerTeam:
				child.modulate = playerColor




func _input(event):
	if event.is_action_pressed("click"):
		
		print ("aoo")
		
		# If you don't haave anyone selected
		if SELECTING == false:
			print ("boo")
			for child in get_children():
				print ("coo")
				if child.is_in_group("Unit"):
					print ("doo")
					if child.MOUSE_OVER == true:
						print ("eoo")
						if child.team == playerTeam:
							print ("foo")
							childSelected = child
							child.SELECTED = true
							SELECTING = true
							$selecting.visible = true
							return

		
		# If you DO have someone selected
		else:
			$selecting.visible = false
			childSelected.SELECTED = false
			SELECTING = false
			for child in get_children():
				if child.is_in_group("Unit"):
					if child.MOUSE_OVER == true:
						pass
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
