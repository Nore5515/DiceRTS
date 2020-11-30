extends Spatial



var holding = false

var speed = 0.01


func _input(event):
	if event.is_action_pressed("mmb"):
		holding = true
	if event.is_action_released("mmb"):
		holding = false
	
	if event is InputEventMouseMotion && holding:
		if event.speed.x > 0:
			rotation_degrees.y += speed * event.speed.x
		if event.speed.x < 0:
			rotation_degrees.y += speed * event.speed.x
			
