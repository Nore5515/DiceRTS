extends Sprite


var passButton

var passButtonPressed = false
var tossButtonPressed = false
var pauseButtonPressed = false


func clear():
	passButtonPressed = false
	tossButtonPressed = false
	pauseButtonPressed = false
	$PassTurnButton.pressed = false
	$TossDiceButton.pressed = false
	$PauseGameButton.pressed = false



# Called when the node enters the scene tree for the first time.
func _ready():
	passButton = get_node("PassTurnButton")


func _input(event):
	if event is InputEventKey:
		var uniKey = event.unicode
		if passButtonPressed:
			newButton($PassTurnButton, uniKey, event)
		elif tossButtonPressed:
			newButton($TossDiceButton, uniKey, event)
		elif pauseButtonPressed:
			newButton($PauseGameButton, uniKey, event)



func newButton(button, uni, event):
	if char(uni) == "":
		if event.scancode == KEY_CONTROL:
			button.text = "Ctrl"
			passButtonPressed = false
			button.pressed = false
		elif char(uni) == " ":
			button.text = "Space"
			passButtonPressed = false
			button.pressed = false
	else:
		button.text = char(uni)
		passButtonPressed = false
		button.pressed = false


func _on_PassTurnButton_pressed():
	clear()
	passButtonPressed = true
	$PassTurnButton.pressed = true


func _on_PauseGameButton_pressed():
	clear()
	pauseButtonPressed = true
	$PauseGameButton.pressed = true


func _on_TossDiceButton_pressed():
	clear()
	tossButtonPressed = true
	$TossDiceButton.pressed = true
