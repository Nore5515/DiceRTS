extends Control



var dragging = false
var dragStart = Vector2(0,0)
var rect: Rect2

var rects = []

func _input(event):
		
	if event.is_action_pressed("click"):
		dragging = true
		dragStart = get_global_mouse_position()
		#rects = []
		update()
	if event.is_action_released("click"):
		dragging = false
		rect = Rect2(dragStart, get_global_mouse_position() - dragStart)
		#print ("Drag Start:", dragStart)
		#print ("Mouse Pos:", get_global_mouse_position())
		update()
		
	if event is InputEventMouseMotion && dragging:
		update()



func isShapeInBox(unit):
	var unitExtents = unit.get_node("Collider").shape.extents
	var box = Rect2(unit.global_position-unitExtents, unitExtents * 2)
	#rects.append(box)
	if rect.intersects(box, true):
		return true
	else:
		if rect.encloses(box):
			return true
		elif box.encloses(rect):
			return true
	return false 

func isPointInBox(point: Vector2):
	return rect.has_point(point)


func _draw():
	
	#for rect in rects:
	#	draw_rect(rect, Color(0.5,0.5,0.5))
	
	if dragging:
		draw_rect(Rect2(dragStart, get_global_mouse_position() - dragStart),
			Color(.5, .5, .5), true)
		#draw_rect(Rect2(dragStart, get_global_mouse_position() - dragStart),
		#	Color(.5, .5, .5), true)
	
