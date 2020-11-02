extends Node2D




export (int) var playerTeam = 1
export (Color) var playerColor

var SELECTING = false
var PAUSED = false

var childSelected


func _ready():
	for child in get_children():
		if child.is_in_group("Unit"):
			if child.team == playerTeam:
				child.modulate = playerColor




func _input(event):
	if event.is_action_pressed("click"):
		
		# If you don't haave anyone selected
		if SELECTING == false:
			for child in get_children():
				if child.is_in_group("Unit"):
					if child.MOUSE_OVER == true:
						if child.team == playerTeam:
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
						return
			
			# If you didn't click anyone it'll just move there
			childSelected.dest = get_global_mouse_position()
			childSelected.moving = true
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
