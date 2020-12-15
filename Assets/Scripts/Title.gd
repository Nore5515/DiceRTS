extends Node2D


var difficulty = "med"

var hoveringEasy = false





#func _ready():
	#$LoadingScreen.sink()
	


func _on_start_pressed():
	get_node("/root/Global").difficulty = difficulty
	$LoadingScreen.rise()
	


#func _on_options_pressed():
	#$optionsMenu.visible = !$optionsMenu.visible
	#if has_node("new"):
		#$new.queue_free()


func _on_TextureButton_pressed():
	pass # Replace with function body.


func clearAll():
	print ("Yep")
	$optionsMenu/easy.pressed = false
	$optionsMenu/med.pressed = false
	$optionsMenu/hard.pressed = false
	$optionsMenu/insane.pressed = false

func _on_easy_pressed():
	clearAll()
	$optionsMenu/easy.pressed = true
	difficulty = "easy"

func _on_med_pressed():
	clearAll()
	$optionsMenu/med.pressed = true
	difficulty = "med"

func _on_hard_pressed():
	clearAll()
	$optionsMenu/hard.pressed = true
	difficulty = "hard"

func _on_insane_pressed():
	clearAll()
	$optionsMenu/insane.pressed = true
	difficulty = "insane"




func _on_LoadingScreen_animationComplete():
	get_tree().change_scene("res://Scenes/Campaign.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/End.tscn")



func _on_Down_pressed():
	get_node("/root/Global").decreaseVolume()


func _on_Up_pressed():
	get_node("/root/Global").increaseVolume()
