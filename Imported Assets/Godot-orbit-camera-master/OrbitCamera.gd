extends Spatial

# Control variables
export var maxPitch : float = 45
export var minPitch : float = -45
export var maxZoom : float = 20
export var minZoom : float = 4
export var zoomStep : float = 2
export var zoomYStep : float = 0.15
export var verticalSensitivity : float = 0.002
export var horizontalSensitivity : float = 0.002
export var camYOffset : float = 4.0
export var camLerpSpeed : float = 16.0
export(NodePath) var target

var obj

# Private variables
var _camTarget : Spatial = null
var _cam : ClippedCamera
var _curZoom : float = 0.0

var maxMoveSpeed = 0.15
#var currentMoveSpeed = 0.0


var speed = 12
var lefting = false
var righting = false
var uping = false
var downing = false

var holding = false


func _ready() -> void:
	
	obj = get_node(target)
	
	# Setup node references
	_camTarget = get_node(target)
	_cam = get_node("ClippedCamera")
	
	# Setup camera position in rig
	_cam.translate(Vector3(0,camYOffset,maxZoom))
	_curZoom = maxZoom

func _input(event) -> void:
	if event is InputEventMouseMotion && holding:
		# Rotate the rig around the target
		rotate_y(-event.relative.x * horizontalSensitivity)
		rotation.x = clamp(rotation.x - event.relative.y * verticalSensitivity, deg2rad(minPitch), deg2rad(maxPitch))
		orthonormalize()
	
	if event.is_action_pressed("mmb"):
		holding = true
	if event.is_action_released("mmb"):
		holding = false
			
	
	if event.is_action_pressed("left"):
		lefting = true
	elif event.is_action_released("left"):
		lefting = false
	if event.is_action_pressed("right"):
		righting = true
	elif event.is_action_released("right"):
		righting = false
	if event.is_action_pressed("up"):
		uping = true
	elif event.is_action_released("up"):
		uping = false
	if event.is_action_pressed("down"):
		downing = true
	elif event.is_action_released("down"):
		downing = false
	
		
	if event is InputEventMouseButton:
		# Change zoom level on mouse wheel rotation
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP and _curZoom > minZoom:
				_curZoom -= zoomStep
				camYOffset -= zoomYStep
			if event.button_index == BUTTON_WHEEL_DOWN and _curZoom < maxZoom:
				_curZoom += zoomStep
				camYOffset += zoomYStep

func _process(delta) -> void:
	# zoom the camera accordingly
	_cam.set_translation(_cam.translation.linear_interpolate(Vector3(0,camYOffset,_curZoom),delta * camLerpSpeed))
	# set the position of the rig to follow the target
	set_translation(_camTarget.global_transform.origin)
	


	var movement = Vector3(0,0,0)
	if lefting:
		movement.x -= maxMoveSpeed
	if righting:
		movement.x += maxMoveSpeed
	if uping:
		movement.z -= maxMoveSpeed
	if downing:
		movement.z += maxMoveSpeed
	
	if movement != Vector3(0,0,0):
		obj.transform.basis.x = transform.basis.x
		obj.transform.basis.z = transform.basis.z
		obj.translate(movement)
		obj.transform.origin.y = -0.5
		obj.transform.origin.x = clamp(obj.transform.origin.x, -11, 11)
		obj.transform.origin.z = clamp(obj.transform.origin.z, -4, 4)
		
		#print (transform.basis)
	
	"""
	if lefting:
		rotate_y(-speed * horizontalSensitivity)
		orthonormalize()
	if righting:
		rotate_y(speed * horizontalSensitivity)
		orthonormalize()
	if uping:
		rotation.x = clamp(rotation.x - speed * verticalSensitivity, deg2rad(minPitch), deg2rad(maxPitch))
		orthonormalize()
	if downing:
		rotation.x = clamp(rotation.x - speed * verticalSensitivity * (-1.0), deg2rad(minPitch), deg2rad(maxPitch))
		orthonormalize()
	"""
	
