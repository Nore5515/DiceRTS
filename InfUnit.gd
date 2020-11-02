extends KinematicBody2D



var HP = 3
var attack = 1
var defense = 1
export (int) var team = 0

var speed = 100
var dest
var moving = false


var MOUSE_OVER = false
var SELECTED = false


func _on_InfUnit_mouse_entered():
	print ("over")
	MOUSE_OVER = true


func _on_InfUnit_mouse_exited():
	print ("not")
	MOUSE_OVER = false


func _process(delta):
	
	if moving:
		$target.global_position = dest
		$target.visible = true
		var dir = dest - self.global_position
		dir = dir * 100000
		dir = dir.clamped(speed)
		move_and_collide(dir * delta)
		if self.global_position.distance_to(dest) < 3:
			moving = false
	else:
		$target.visible = false
	
	
	if SELECTED:
		$box.visible = true
	else:
		$box.visible = false
		
