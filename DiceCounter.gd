extends Spatial




var dice = []

var kickCharge = 0
var kickCharging = false

var diceTotal = 0

var shake = 0.0


func _ready():
	dice = get_tree().get_nodes_in_group("dice")


func _process(delta):
	
	if dice.size() > 0:
		for die in dice:
			if die.value != -1:
				diceTotal += die.value
				dice.erase(die)

	$Label.text = String(diceTotal)
	$charge.text = String(round(kickCharge))
	
	if kickCharging:
		kickCharge += 0.2
		
	if shake > 0:
		print ("shaking")
		shake -= 0.01
		get_node("Camera").setOffset(shake)
	elif shake < 0:
		shake = 0
		print ("reset")
		get_node("Camera").setOffset(0)
		


func _input(event):
	if event.is_action_pressed("kick"):
		kickCharging = true
	
	elif event.is_action_released("kick"):
		for die in get_tree().get_nodes_in_group("dice"):
			die.kick(kickCharge)
		kickCharging = false
		shake = kickCharge * 0.05
		kickCharge = 0
		dice = get_tree().get_nodes_in_group("dice")
		diceTotal = 0
