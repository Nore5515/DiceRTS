extends TextureButton


var initPos
var finalPos

var goingUp = false
var moving = false

func _ready():
	finalPos = $Node2D.global_position
	initPos = $Node2D.global_position
	initPos.y += 3000
	$Node2D.global_position = initPos



func _on_helpButton_pressed():
	moving = true
	if goingUp:
		goingUp = false
	elif !goingUp:
		goingUp = true
		$Node2D.visible = true
		get_parent().get_node("optionsClosed").disable()
		


func _process(delta):
	if moving:
		if goingUp:
			$Node2D.global_position = lerp($Node2D.global_position, finalPos, 0.1)
			if $Node2D.global_position.distance_to(finalPos) < 1.0:
				moving = false
		if !goingUp:
			$Node2D.global_position = lerp($Node2D.global_position, initPos, 0.1)
			if $Node2D.global_position.distance_to(initPos) < 1.0:
				$Node2D.visible = false
				moving = false


func clearAll():
	$Node2D/help0.visible = false
	$Node2D/help1.visible = false
	$Node2D/help2.visible = false



func _on_Button_pressed():
	clearAll()
	$Node2D/help1.visible = true
	$Timer.start()
	$Node2D/helpBox/AnimatedSprite.play("talk")


func _on_Button2_pressed():
	clearAll()
	$Node2D/help2.visible = true
	$Timer.start()
	$Node2D/helpBox/AnimatedSprite.play("talk")

func _on_Button3_pressed():
	clearAll()
	#$help3.visible = true
	#$Timer.start()
	#$helpBox/AnimatedSprite.play("talk")

func _on_Button4_pressed():
	clearAll()
	#$Timer.start()
	#$helpBox/AnimatedSprite.play("talk")

func _on_Timer_timeout():
	$Node2D/helpBox/AnimatedSprite.play("default")



