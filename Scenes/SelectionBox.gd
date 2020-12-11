extends Control


############ Doesn't show box on super zooomed????
############ Sometimes box doesn't select...
############ might not be this though.


var dragging = false
var dragStart = Vector2(0,0)

var rect: Rect2

var rects = []

export (NodePath) var battlemap

func _input(event):
		
	if event.is_action_pressed("click"):
		rect = Rect2(-100000,-100000,0,0)
		dragging = true
		dragStart = get_global_mouse_position()
		get_node(battlemap).updateSelection()
		rects = []
		update()

	if event.is_action_released("click"):
		dragging = false
		#print ("Drag Start:", dragStart)
		#print ("Mouse Pos:", get_global_mouse_position())
		update()
		get_node(battlemap).updateSelection()
		
	if event is InputEventMouseMotion && dragging:
		rect = Rect2(dragStart, get_global_mouse_position() - dragStart)
		rect = reRect(rect)
		update()


# Is a in b?
func totallyEncloses(a: Rect2, b: Rect2):
	var xYes = false
	var yYes = false
	if a.position.x <= b.end.x && a.position.x >= b.position.x:
		print ("a's position X lines up")
		if a.end.x <= b.end.x && a.end.x >= b.position.x:
			print ("a's end X lines up")
			xYes = true
	if a.position.y >= b.end.y && a.position.y <= b.position.y:
		print ("a's position Y lines up")
		if a.end.y >= b.end.y && a.end.y <= b.position.y:
			print ("a's end X lines up")
			yYes = true
	if xYes && yYes:
	#	print ("WITHIN BOUNDS")
		return true


# instead of growing negative, just make it a normal rectangle 
# that STARTS from the topleft
func reRect(oldRect: Rect2) -> Rect2:
	var begining = Vector2()
	var end = Vector2()
	var newRect = Rect2()
	if oldRect.size.x < 0:
		if oldRect.size.y > 0:
			newRect.position = oldRect.position
			newRect.position.x += oldRect.size.x
			newRect.size.x = oldRect.size.x * -1
			newRect.size.y = oldRect.size.y
		else:
			newRect = oldRect
	else:
		newRect = oldRect
	return newRect


func isShapeInBox(unit):
	#print ("Called inBox on unit ", unit.name)
	var unitExtents = unit.get_node("Collider").shape.extents
	var box = Rect2(unit.global_position-unitExtents, unitExtents * 2)
	#print ("Unit Extents:" , unitExtents, "\tHitbox:", box)
	#print ("Detection Rect:", rect)
	#print ("Is ", box, " hitting ", rect, "?")
	rects.append(box)
	if rect.intersects(box, true):
		#rects.append(box)
		#print ("Unit in box") 
		return true
	elif box.intersects(rect, true):
		#print ("Unit in box") 
		return true
	else:
		#print("Enclosed?")
		if rect.encloses(box):
			#rects.append(box)
			#print ("Unit in box")
			return true
		elif box.encloses(rect):
			#rects.append(box)
			#print ("Unit in box")
			return true
		else:
			if totallyEncloses(box, rect):
				return true
			else:
				#print ("Nope...")
				return false 


func isPointInBox(point: Vector2):
	return rect.has_point(point)


func _draw():
	
	#draw_rect(reRect(Rect2(0,0,-100,100)), Color(1,0,0))
	#draw_rect(Rect2(0,0,-100,100), Color(0,1,0))
	
	for rect in rects:
		draw_rect(rect, Color(0.5,0.5,0.5))
	
	if dragging:
		#print ("You are dragging.")
		if rect != null:
			#print ("Drawing Rect.", rect)
			draw_rect(rect,
				Color(.5, .5, .5), true)
		#else:
			#print ("Rect appears to be null.")
	#else:
		#print ("You are NOT dragging.")
		#draw_rect(Rect2(dragStart, get_global_mouse_position() - dragStart),
		#	Color(.5, .5, .5), true)
	
