extends Node2D


var dicePath

var dice = []
var enemyDice = []
var alliedDice = []

export (Color) var enemyColor
export (Color) var alliedColor

var done = false
var ready = false

var attackingUnit
var defendingUnit

var badDice
var goodDice

var allyDestroyed = false
var enemyDestroyed = false

var gameOver = false

func _ready():
	dicePath = load("res://Scenes/Dice2D.tscn")
	#rollDice(7)
	
	$Hint.text = "Press Space to toss dice"


# ADD RUN AWAY OPTION BETWEEN BATTLES

func _input(event):
	if event.is_action_pressed("Space") && ready:
		print ("Begin!")
		$Hint.text = ""
		clearAll()
		print (defendingUnit.myUnit.stats["Strength"])
		rollBadDice(defendingUnit.myUnit.stats["Strength"])
		rollGoodDice(attackingUnit.myUnit.stats["Strength"])
		ready = false
	elif event.is_action_pressed("Space") && gameOver:
		clearAll()
		get_parent().get_parent().ENGAGED = false
		get_parent().get_parent().DETECTED = false
		get_parent().get_parent().retractBox()
		get_parent().get_parent().clearUnitValues()
		#get_parent().get_parent().get_node("zoomTime").start()
		if attackingUnit.myUnit.stats["HP"] <= 0:
			attackingUnit.queue_free()
		if defendingUnit.myUnit.stats["HP"] <= 0:
			defendingUnit.queue_free()
		gameOver = false
		ready = false



func _process(delta):
	if diceRolling() && !done:
		$YourTotal.text = "Your Total: " + String(alliedTotal())
		$EnemyTotal.text = "Enemy Total: " + String(enemyTotal())
	elif !diceRolling() && !done:
		updateText()
		done = true
	else:
		# dont spam updates when not necessary (done = areDiceRolling)
		pass
		


func updateText():
	print  ("Updating Text")
	$YourTotal.text = "Your Total: " + String(alliedTotal())
	$EnemyTotal.text = "Enemy Total: " + String(enemyTotal())
	updateStrength()
	if alliedTotal() != 0 && enemyTotal() != 0:
		$Results.text = getResults()
		if attackingUnit.myUnit.stats["HP"] > 0 && defendingUnit.myUnit.stats["HP"] > 0:
			ready = true


func updateStrength():
	if attackingUnit != null && defendingUnit != null:
		$YourStrength.text = "Strength: " + String(attackingUnit.myUnit.stats["Strength"])
		$EnemyStrength.text = "Strength: " + String(defendingUnit.myUnit.stats["Strength"])


func fight(aUnit, eUnit):
	print ("Start the fight!")
	attackingUnit = aUnit
	defendingUnit = eUnit
	
	$AllyIcon.setPic(attackingUnit.getType())
	$EnemyIcon.setPic(defendingUnit.getType())
	
	goodDice = attackingUnit.myUnit.stats["Strength"]
	badDice = defendingUnit.myUnit.stats["Strength"]
	
	ready = true
	
	resetHP(attackingUnit.myUnit.stats["HP"], defendingUnit.myUnit.stats["HP"])


func end():
	print ("End the fight!")
	if attackingUnit.myUnit.stats["HP"] <= 0:
		$BattleResults.text = "ENGAGEMENT LOST"
		if allyDestroyed:
			$BattleResults.text += " - " + attackingUnit.myUnit.name + " DEFEATED"
	if defendingUnit.myUnit.stats["HP"] <= 0:
		$BattleResults.text = "ENGAGEMENT WON"
		if enemyDestroyed:
			$BattleResults.text += " - ENEMY DEFEATED"
	$Hint.text = "Press Space to return to battlemap"
	gameOver = true


func resetHP(allyHP: int, enemyHP: int):
	$AllyHP.clear()
	$EnemyHP.clear()
	$AllyHP.addHP(allyHP)
	$EnemyHP.addHP(enemyHP)


func hurtAlly(amount: int):
	#if attackingUnit.myUnit.stats["HP"] - amount < 0:
	#	attackingUnit.myUnit.stats["HP"] = 0
	#else:
	#	attackingUnit.myUnit.stats["HP"] -= amount
	print ("dealing ", amount, " to ally")
	attackingUnit.myUnit.harm(amount)
	$AllyHP.removeHP(amount)
	#updateText()
	updateStrength()
	if attackingUnit.myUnit.stats["HP"] <= 0:
		end()

func hurtEnemy(amount: int):
	#if defendingUnit.myUnit.stats["HP"] - amount < 0:
	#	defendingUnit.myUnit.stats["HP"] = 0
	#else:
	#	defendingUnit.myUnit.stats["HP"] -= amount
	print ("dealing ", amount, " to enemy")
	defendingUnit.myUnit.harm(amount)
	$EnemyHP.removeHP(amount)
	#updateText()
	updateStrength()
	if defendingUnit.myUnit.stats["HP"] <= 0:
		end()



func getResults() -> String:
	print ("Getting results...")
	if alliedTotal() > enemyTotal():
		if alliedTotal() > enemyTotal() + 5:
			hurtEnemy(2)
			return "TOTAL VICTORY"
		hurtEnemy(1)
		return "VICTORY"
	elif alliedTotal() == enemyTotal():
		return "TIE"
	else:
		if alliedTotal() + 5 < enemyTotal():
			hurtAlly(2)
			return "TOTAL DEFEAT"
		hurtAlly(1)
		return "DEFEAT"


func diceRolling() -> bool:
	for child in get_node("DiceMom").get_children():
		if child.is_in_group("Dice2D"):
			if child.get_child(0).rolling:
				return true
	return false


func enemyTotal() -> int:
	var total = 0
	for die in enemyDice:
		total += die.get_child(0).value
	return total

func alliedTotal() -> int:
	var total = 0
	for die in alliedDice:
		total += die.get_child(0).value
	return total


func clearAll():
	dice = clearList(dice)
	enemyDice = clearList(enemyDice)
	alliedDice = clearList(alliedDice)


func clearList(list: Array):
	for item in list:
		item.call_deferred("queue_free")
	list = []
	return list


func rollBadDice(count: int):
	rollDice(count, enemyColor, "enemyDice")

func rollGoodDice(count: int):
	rollDice(count, alliedColor, "alliedDice")


func rollDice(count: int, tint: Color = Color.white, list: String = "dice"):
	var newColor = tint
	var instance
	done = false
	$Results.text = ""
	
	for x in range(count):
		instance = dicePath.instance()
		get_node("DiceMom").add_child(instance)
		instance.global_position = Vector2(\
			rand_range($upperleft.global_position.x,$bottomRight.global_position.x),\
			rand_range($upperleft.global_position.y,$bottomRight.global_position.y)\
		)
		instance.get_child(0).roll()
		instance.modulate = newColor
		if list == "dice":
			dice.append(instance)
		elif list == "enemyDice":
			enemyDice.append(instance)
		elif list == "alliedDice":
			alliedDice.append(instance)
		else:
			print ("ERR")
