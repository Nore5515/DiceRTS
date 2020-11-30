extends Area2D


export (bool) var unpassable = false


func _on_Slowdown_body_entered(body):
	if !unpassable:
		if body.is_in_group("Unit"):
			body.SLOWED = true
			print ("SLOWED")
	else:
		if body.is_in_group("Unit"):
			body.MEGASLOWED = true
			print ("SLOWED")

func _on_Slowdown_body_exited(body):
	if !unpassable:
		if body.is_in_group("Unit"):
			body.SLOWED = false
	else:
		if body.is_in_group("Unit"):
			body.MEGASLOWED = false
