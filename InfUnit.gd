extends KinematicBody2D



var HP = 3
var attack = 1
var defense = 1
export (int) var team = 0

var speed = 10
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
		var dir = dest - self.global_position
		move_and_collide(dir * speed * delta)