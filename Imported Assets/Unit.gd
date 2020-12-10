extends KinematicBody2D

var DEBUG_DRAW = true

export var speed = 100  # Movement speed.
var av = Vector2.ZERO  # Avoidance vector.
var avoid_weight = 0.1  # How strongly to avoid other units.
var target_radius = 50  # Stop when this close to target.
var target = null setget set_target  # Set this to move.
var selected = false setget set_selected  # Is this unit selected?
var velocity = Vector2.ZERO

func _ready():
	# Make sure the material is unique to this unit.
	$Sprite.material = $Sprite.material.duplicate()
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	if target:
		# If there's a target, move toward it.
		velocity = position.direction_to(target)
		if position.distance_to(target) < target_radius:
			target = null
	# Find avoidance vector and add to velocity.
	av = avoid()
	velocity = (velocity + av * avoid_weight).normalized()
	if velocity.length() > 0:
		# Rotate body to point in movement direction.
		rotation = velocity.angle()
	var collision = move_and_collide(velocity * speed * delta)
	update()

func set_selected(value):
	# Draw a highlight around the unit if it's selected.
	selected = value
	if selected:
		$Sprite.material.set_shader_param("aura_width", 1)
	else:
		$Sprite.material.set_shader_param("aura_width", 0)
		
func set_target(value):
	target = value

func avoid():
	# Calculates avoidance vector based on nearby units.
	var result = Vector2.ZERO
	var neighbors = $Detect.get_overlapping_bodies()
	if !neighbors:
		return result
	for n in neighbors:
		result += n.position.direction_to(position)
	result /= neighbors.size()
	return result.normalized()
	
func _draw():
	# Draws some debug vectors.
	if !DEBUG_DRAW:
		return
	draw_circle(Vector2.ZERO, $Detect/CollisionShape2D.shape.radius,
				Color(1, 1, 0, 0.2))
	draw_line(Vector2.ZERO, av.rotated(-rotation)*50, Color(1, 0, 0), 5)
	draw_line(Vector2.ZERO, velocity.rotated(-rotation)*speed, Color(0, 1, 0), 5)
	if target:
		draw_line(Vector2.ZERO, position.direction_to(target).rotated(-rotation)*50,
			Color(0, 0, 1), 5)
