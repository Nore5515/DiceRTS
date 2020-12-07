extends Sprite



var activated = false
var moving = false

var mousingOver = false

var waitingForClick = false

var mousingOverButton = false

var popping = false
var poppingFlag = false
var poppingFlag2 = false

var optionsMenu

var mousingOverMenu = false

var ControlInstance

var bad = false


func _ready():
	optionsMenu = get_parent().get_node("optionsMenu")
	visible = false
	disable()


func activate():
	activated = true
	moving = true
	visible = true

func disable():
	activated = false
	moving = true
	waitingForClick = false
	optionsMenu.visible = false
	
	ControlInstance = load("res://Scenes/Control.tscn").instance()
	get_parent().call_deferred("add_child", ControlInstance)
	ControlInstance.connect("mouse_entered", self, "_on_Control_mouse_entered")
	ControlInstance.connect("mouse_exited", self, "_on_Control_mouse_exited")
	

func _process(delta):
	if moving:
		if activated:
			self.scale = lerp(self.scale, Vector2(1.0, 1.0), 0.1)
			if self.scale.distance_to(Vector2(1.0, 1.0)) < 0.05:
				moving = false
				waitingForClick = true
		else:
			self.scale = lerp(self.scale, Vector2(0, 0), 0.3)
			if self.scale.distance_to(Vector2(0.0, 0.0)) < 0.05:
				moving = false
				visible = false
	
	elif popping:
		if poppingFlag == false:
			self.scale = lerp(self.scale, Vector2(0.8, 0.8), 0.3)
			if self.scale.distance_to(Vector2(0.8, 0.8)) < 0.05:
				poppingFlag = true
		elif poppingFlag == true && poppingFlag2 == false:
			self.scale = lerp(self.scale, Vector2(1.2, 1.2), 0.3)
			if self.scale.distance_to(Vector2(1.2, 1.2)) < 0.05:
				poppingFlag2 = true
		else:
			self.scale = lerp(self.scale, Vector2(1.0, 1.0), 0.3)
			if self.scale.distance_to(Vector2(1.0, 1.0)) < 0.05:
				popping = false
				openNotebook()


func open():
	if optionsMenu.visible == false:
		popping = true
		poppingFlag = false
		poppingFlag2 = false


func _input(event):
	
	if event.is_action_pressed("click"):
		#print ("==========\n")
		if mousingOverButton == false:
			#print ("mousingOverButton is false")
			if mousingOver == false:
				if bad:
					disable()
			else:
				#print ("mousing over Control is TRUE")
				if visible:
					open()
				
				
func openNotebook():
	optionsMenu.visible = true
	ControlInstance.queue_free()
	mousingOver = false





func _on_options_pressed():
	if !waitingForClick:
		if !activated:
			activate()


func _on_optionsButton_mouse_entered():
	mousingOverButton = true


func _on_optionsButton_mouse_exited():
	mousingOverButton = false


func _on_MainOptionsButton_mouse_entered():
	mousingOverMenu = true
	#print ("Mousing over options menu")


func _on_MainOptionsButton_mouse_exited():
	mousingOverMenu = false


func _on_Area2D_mouse_entered():
	pass#mousingOver = true


func _on_Area2D_mouse_exited():
	pass#mousingOver = false



func _on_Control_mouse_entered():
	#print ("OVER")
	mousingOver = true


func _on_Control_mouse_exited():
	#print ("NOT")
	mousingOver = false



func _on_BADS_mouse_entered():
	#print ("BAD")
	bad = true

func _on_BADS_mouse_exited():
	#print ("not bad :)")
	bad = false
