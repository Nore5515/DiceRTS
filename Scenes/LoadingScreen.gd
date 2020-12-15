extends AnimatedSprite



export (bool) var rising = false
export (bool) var sinking = false



signal animationComplete


func rise():
	print ("Rose")
	rising = true
	play("default")


func sink():
	print ("Sank")
	sinking = true
	play("default")


func _process(delta):
	if rising:
		#print (frame)
		self.position.y = lerp (self.position.y, -5.0, 0.1)
	elif sinking:
		#print (frame)
		self.position.y = lerp (self.position.y, 1500, 0.1)




func _on_LoadingScreen_animation_finished():
	emit_signal("animationComplete")
	print ("DEATH", get_parent().get_children())
	call_deferred("queue_free", self)
	queue_free()
