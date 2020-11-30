extends Spatial



var minX = 0
var maxX = 0
var minY = 0
var maxY = 0

var movingLeft = false
var movingRight = false
var movingUp = false
var movingDown = false

var rotRangeX = 30
var rotRangeY = 10

var rotDest = Vector3(0,0,0)


var clicking = false


func _ready():
	var screenSize = OS.window_size
	
	minX = screenSize.x * 0.35
	maxX = screenSize.x * 0.65
	minY = screenSize.y * 0.35
	maxY = screenSize.y * 0.65



func _process(delta):
	print ($CameraAnchor/Camera.rotation_degrees)
	
	
	var mouseLoc = get_viewport().get_mouse_position()
	
	if mouseLoc.x < minX:
		movingLeft = true
	else:
		movingLeft = false

	if mouseLoc.x > maxX:
		movingRight = true
	else:
		movingRight = false

	if mouseLoc.y < minY:
		movingUp = true
	else:
		movingUp = false

	if mouseLoc.y > maxY:
		movingDown = true
	else:
		movingDown = false
	
	
	var moving = false
	var newRotation = Vector3(0,0,0)
	if movingUp:
		newRotation.x += 1 * (abs(mouseLoc.y - minY)/minY) * 0.5
		moving = true
	if movingDown:
		newRotation.x += -1 * (abs(mouseLoc.y - maxY)/maxY) * 0.5
		moving = true
	if movingLeft:
		newRotation.y += 1 * (abs(mouseLoc.x - minX)/minX)
		moving = true
	if movingRight:
		newRotation.y += -1 * (abs(mouseLoc.x - maxX)/maxX)
		moving = true
	
	$CameraAnchor/Camera.rotation_degrees += newRotation
	if $CameraAnchor/Camera.rotation_degrees.x < -30 - rotRangeX:
		$CameraAnchor/Camera.rotation_degrees.x = lerp($CameraAnchor/Camera.rotation_degrees.x ,-30 - rotRangeX, 0.1)
	elif $CameraAnchor/Camera.rotation_degrees.x > -30 + rotRangeX:
		$CameraAnchor/Camera.rotation_degrees.x = lerp($CameraAnchor/Camera.rotation_degrees.x ,-30 + rotRangeX, 0.1)
	if $CameraAnchor/Camera.rotation_degrees.y < 0 - rotRangeX:
		$CameraAnchor/Camera.rotation_degrees.y = lerp($CameraAnchor/Camera.rotation_degrees.y ,0 - rotRangeX, 0.1)
	elif $CameraAnchor/Camera.rotation_degrees.y > 0 + rotRangeX:
		$CameraAnchor/Camera.rotation_degrees.y = lerp($CameraAnchor/Camera.rotation_degrees.y ,0 + rotRangeX, 0.1)
	
	if moving == false && !clicking:
		print ("relaxed")
		$CameraAnchor/Camera.rotation_degrees = lerp($CameraAnchor/Camera.rotation_degrees, Vector3(-30,0,0), 0.05)
	
	
	if clicking:
		rotRangeX = 40
		rotRangeY = 20
		if $CameraAnchor/Camera.fov != 30:
			$CameraAnchor/Camera.fov = lerp($CameraAnchor/Camera.fov, 30, 0.1)
			if abs($CameraAnchor/Camera.fov - 30) < 0.02:
				 $CameraAnchor/Camera.fov = 30
		#var mousePos3D = $CameraAnchor/Camera.project_ray_normal(mouseLoc)
		#$CameraAnchor/Camera.look_at(mousePos3D, Vector3(0,1,0))
	else:
		rotRangeX = 20
		rotRangeY = 10
		if $CameraAnchor/Camera.fov != 70:
			$CameraAnchor/Camera.fov = lerp($CameraAnchor/Camera.fov, 70, 0.1)
			if abs($CameraAnchor/Camera.fov - 70) < 0.02:
				 $CameraAnchor/Camera.fov = 70
		#if $CameraAnchor/Camera.rotation_degrees.x != -30:
		#	$CameraAnchor/Camera.rotation_degrees.x = -30
		#if $CameraAnchor/Camera.rotation_degrees.y != 0:
		#	$CameraAnchor/Camera.rotation_degrees.y = 0
	if $CameraAnchor/Camera.rotation_degrees.z != 0:
		$CameraAnchor/Camera.rotation_degrees.z = 0

	if rotDest != Vector3(0,0,0):
		$CameraAnchor.rotation_degrees = lerp($CameraAnchor.rotation_degrees, rotDest, 0.1)

	

func _input(event):

	if event.is_action_pressed("scrollUp"):
		if $CameraAnchor.rotation_degrees.x > -45:
			#$CameraAnchor.rotation_degrees.x -= 3
			rotDest.x -= 3
	if event.is_action_pressed("scrollDown"):
		if $CameraAnchor.rotation_degrees.x < 10:
			#$CameraAnchor.rotation_degrees.x += 3
			rotDest.x += 3

	if event.is_action_pressed("lClick"):
		clicking = true
	if event.is_action_released("lClick"):
		clicking = false
