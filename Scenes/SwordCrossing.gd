extends Node2D



	
func _ready():
	$Tween.interpolate_property($rightSword, "position", 
		$rightSword.position, Vector2(0,0), 1.0, Tween.TRANS_QUART, Tween.EASE_IN)
	$Tween.interpolate_property($leftSword, "position", 
		$leftSword.position, Vector2(0,0), 1.0, Tween.TRANS_QUART, Tween.EASE_IN)
	$Tween.interpolate_property($rightSword, "rotation_degrees", 
		$rightSword.rotation_degrees, 0, 1.0, Tween.TRANS_QUART, Tween.EASE_IN)
	$Tween.interpolate_property($leftSword, "rotation_degrees", 
		$leftSword.rotation_degrees, 0, 1.0, Tween.TRANS_QUART, Tween.EASE_IN)
	$Tween.start()
	$Timer.start()


func _on_Timer_timeout():
	$CPUParticles2D.emitting = true
