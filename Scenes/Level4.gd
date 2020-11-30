extends Node2D





func _ready():
	$Timer.start()


func _on_Timer_timeout():
	var instance = load("res://Scenes/Dice.tscn").instance()
	add_child(instance)
	instance.translation = Vector3(rand_range(-4,4),20,rand_range(-4,4))
	$Timer.wait_time = rand_range(0, 0.4)
	$Timer.start()

func _input(event):
	if event.is_action_pressed("Ctrl"):
		get_tree().change_scene("res://Scenes/Title.tscn")
