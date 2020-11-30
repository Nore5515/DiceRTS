extends RigidBody



var team = -1

var speed = 20

var value = -1

var cocked = false

export (bool) var initSpawn = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if initSpawn:
		doStuff()
	else:
		pass


func _process(delta):
	
	if team == 1:
		get_node("dice").get_surface_material(0).albedo_color = Color("6a9467")
	else:
		get_node("dice").get_surface_material(0).albedo_color = Color("ff6e6e")
	
	
	if get_global_transform().origin.y < -100:
		if get_tree().get_nodes_in_group("win").size() <= 0:
			get_parent().dice.erase(self)
		queue_free()
	
	if value == -1:
		
		if linear_velocity.length() < 0.05:
			
			if 0.95 < get_global_transform().basis.x.y && get_global_transform().basis.x.y < 1.05:
				#print ("ONE")
				value = 1
			
			elif -0.95 > get_global_transform().basis.x.y && get_global_transform().basis.x.y > -1.05:
				#print ("THREE")
				value = 3
				
			elif 0.9 < get_global_transform().basis.z.y && get_global_transform().basis.z.y < 1.15:
				#print ("FIVE")
				value = 5
			
			elif -0.9 > get_global_transform().basis.z.y && get_global_transform().basis.z.y > -1.15:
				#print ("TWO")
				value = 2
			
			elif 0.9 < get_global_transform().basis.y.y && get_global_transform().basis.y.y < 1.15:
				#print ("FOUR")
				value = 4
			
			elif -0.9 > get_global_transform().basis.y.y && get_global_transform().basis.y.y > -1.15:
				#print ("SIX")
				value = 6
			
			$Timer.stop()


func doStuff():
	launch(speed)
	rotate_x(rand_range(-30,30))
	rotate_y(rand_range(-30,30))
	rotate_z(rand_range(-30,30))


func launch(force):
	var dest = get_parent().get_node("DEST")
	apply_central_impulse(-get_global_transform().basis.z * force)
	apply_central_impulse(Vector3(0,0.5,0) * force)
	look_at(dest.translation, Vector3(0,1,0))
	$Timer.stop()
	$Timer.start()
	
func kick(force):
	if get_global_transform().origin.y < 3:
		value = -1
		#var dest = Vector3(translation.x, 100, translation.z)
		var dest = Vector3(rand_range(-0.3,0.3), 1, rand_range(-0.3,0.3))
		#look_at(dest, Vector3(0,1,0))
		apply_central_impulse(dest * force)
		apply_torque_impulse(Vector3(rand_range(-0.2,0.2),rand_range(-0.2,0.2),rand_range(-0.2,0.2))*force)
		$Timer.stop()
		$Timer.start()


func _on_Timer_timeout():
	if value == -1:
		cocked = true
		print ("COCKED DIE")
		launch(speed)
		$Timer.start()
