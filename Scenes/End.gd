extends Node2D



func _ready():
	get_node("/root/Global").endMusic()



func _input(event):
	if event.is_action_pressed("Space"):
		get_tree().change_scene("res://Scenes/Campaign.tscn")
	if event.is_action_pressed("esc"):
		get_tree().quit()
