extends Camera2D



var maxSpeed = Vector2(100,100)
var targetSpeed = Vector2(0,0)
var speed = Vector2(0,0)

var left = false
var right = false
var up = false
var down = false


func _process(delta):
	
	if speed.x < targetSpeed.x:
		speed.x = lerp(speed.x, targetSpeed.x, 0.1)
	elif speed.x > targetSpeed.x:
		speed.x = lerp(speed.x, targetSpeed.x, 0.1)
	
	if speed.y < targetSpeed.y:
		speed.y = lerp(speed.y, targetSpeed.y, 0.1)
	elif speed.y > targetSpeed.y:
		speed.y = lerp(speed.y, targetSpeed.y, 0.1)

	if targetSpeed.x > 0:
		targetSpeed.x = lerp(targetSpeed.x, 0, 0.1)
	elif targetSpeed.x < 0:
		targetSpeed.x = lerp(targetSpeed.x, 0, 0.1)
	
	if targetSpeed.y > 0:
		targetSpeed.y = lerp(targetSpeed.y, 0, 0.1)
	elif targetSpeed.y < 0:
		targetSpeed.y = lerp(targetSpeed.y, 0, 0.1)

	
	if targetSpeed.x > maxSpeed.x:
		targetSpeed.x = maxSpeed.x
	elif targetSpeed.y > maxSpeed.y:
		targetSpeed.y = maxSpeed.y


	if left:
		targetSpeed.x -= 1
	if right:
		targetSpeed.x += 1
	if up:
		targetSpeed.y -= 1
	if down:
		targetSpeed.y += 1


	translate(speed)


func _input(event):
	
	if event.is_action_pressed("left"):
		left = true
	elif event.is_action_released("left"):
		left = false
		
	if event.is_action_pressed("right"):
		right = true
	elif event.is_action_released("right"):
		right = false
	
	if event.is_action_pressed("up"):
		up = true
	elif event.is_action_released("up"):
		up = false
	
	if event.is_action_pressed("down"):
		down = true
	elif event.is_action_released("down"):
		down = false
		
	if event.is_action_pressed("scrollDown"):
		if zoom.x < 4:
			zoom.x += 0.1
			zoom.y += 0.1
		else:
			zoom.x = 4
			zoom.y = 4
	if event.is_action_pressed("scrollUp"):
		if zoom.x > 1:
			zoom.x -= 0.1
			zoom.y -= 0.1
		else:
			zoom.x = 1
			zoom.y = 1
	
