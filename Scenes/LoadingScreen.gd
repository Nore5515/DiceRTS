extends AnimatedSprite



export (bool) var rising = false
export (bool) var sinking = false


func rise():
	rising = true
	play("default")


func sink():
	sinking = true
	play("default")


func _process(delta):
	if rising:
		print (frame)
		self.position.y = lerp (self.position.y, -5.0, 0.1)
	elif sinking:
		print (frame)
		self.position.y = lerp (self.position.y, 1500, 0.1)




func _on_LoadingScreen_animation_finished():
	call_deferred("queue_free", self)
