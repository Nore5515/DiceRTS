extends HBoxContainer


var hp: int = 0
var hpBars = []


func _ready():
	add_constant_override("separation", 1)


#func _input(event):
	#if event.is_action_pressed("Ctrl"):
	#	addHP(3)
	#else:
	#	removeHP(1)


func _colorBars():
	var count = 0
	for bar in hpBars:
		if count == 0:
			bar.modulate = Color.red
		elif count == 1:
			bar.modulate = Color.yellow
		else:
			bar.modulate = Color.green
		count += 1


func clear():
	#print ("Clear called")
	hp = 0
	if hpBars.size() > 0:
		print ("Wiping bar!", hpBars)
		for x in range(hpBars.size()):
			print ("removing ", x, " from list.")
			hpBars[x].call_deferred("queue_free")
			print (hpBars)
		hpBars = []


func addHP(amount: int):
	#print ("HP adding from ", hp, " to ", hp + amount)
	#print ("\t", hpBars)
	hp += amount
	
	var instance
	for x in range(amount):
		instance = load("res://Scenes/Bar.tscn").instance()
		add_child(instance)
		hpBars.append(instance)
	_colorBars()

func removeHP(amount: int):
	#print ("HP removing from ", hp, " to ", hp - amount)
	#print ("\t", hpBars)
	hp -= amount
	
	if hp <= 0:
		hp = 0
		for x in range(hpBars.size()):
			hpBars[x].call_deferred("queue_free")
		hpBars = []
	else:
		for x in range (amount):
			hpBars[x].queue_free()
			hpBars.remove(x)
	_colorBars()

