extends Spatial




var dice = []

var kickCharge = 0
var kickCharging = false

var kicked = false

var NOKICKING = false

var diceTotal = 0

var shake = 0.0

var YOURTURN = false
var WAITING_FOR_DICE = false
var DONE_WITH_DICE = false
var WAITING_FOR_PLAYER = false

var DONE = false
var HPCALC = false

var alliedDice = 3#-1
var enemyDice = 3#-1

var alliedDamageDealt = -1
var enemyDamageDealt = -1

var alliedResult
var enemyResult

var alliedHP 


var damagesActive = []

var enemies = []


func _ready():
	dice = get_tree().get_nodes_in_group("dice")
	
	var global = get_node("/root/Global")
	
	if global.kickedEngagement == true || global.kickedBattle == true:
		$kick.modulate = $kick.modulate * 0.5
	
	if global.enemiesEngaged.size() > 0:
		queueEnemy(global.enemiesEngaged[0])
	else:
		var allyName = "Allied " 
		var enemyName = "Enemy " 
		if "Inf" in global.alliedName:
			allyName += "Infantry"
		elif "Veh" in global.alliedName:
			allyName += "Armored Vehicle"
		elif "Art" in global.alliedName:
			allyName += "Mobile Artillery"
		if "Inf" in global.enemyName:
			enemyName += "Infantry"
		elif "Veh" in global.enemyName:
			enemyName += "Armored Vehicle"
		elif "Art" in global.enemyName:
			enemyName += "Mobile Artillery"
		$alliedName.text = allyName
		$alliedHP.text = "Allied HP: " + String(global.alliedHP)
		alliedDice = global.alliedDice
		$enemyName.text = enemyName
		$enemyHP.text = "Enemy HP: " + String(global.enemyHP)
		enemyDice = global.enemyDice
		
	if global.defenderAllied:
		$defenderAllied.visible = true
	elif global.defenderEnemy:
		$defenderEnemy.visible = true



func queueEnemy(unit):
	$enemyName.text = unit.name
	$enemyHP.text = "Enemy HP: " + String(unit.HP)
	enemyDice = unit.attack



func _process(delta):
	
	
	if NOKICKING:
		$progressBar.scale.x = 0
		kickCharge = 0
		kickCharging = false
	
	
	if WAITING_FOR_PLAYER:
		$Camera.fov = lerp($Camera.fov, 25, 0.01)
		NOKICKING = true
	
	if damagesActive.size() > 0:
		var temp 
		for dmg in damagesActive:
			temp = get_node(dmg)
			if temp.modulate.a > 0.01:
				temp.modulate.a = lerp(temp.modulate.a, 0, 0.05)
			else:
				temp.modulate.a = 1
				damagesActive.erase(dmg)
				get_node(dmg).visible = false
	
	
	if dice.size() > 0:
		for die in dice:
			if die.value != -1:
				diceTotal += die.value
				dice.erase(die)
	
	
	if alliedDice <= 0 && DONE == false && WAITING_FOR_PLAYER == false:
		WAITING_FOR_DICE = true
	
	
	if WAITING_FOR_DICE:
		#print ("WAITING FOR DICE", delta)
		DONE_WITH_DICE = true
		for die in get_tree().get_nodes_in_group("dice"):
			if die.value == -1:
				DONE_WITH_DICE = false
		if DONE_WITH_DICE:
			print ("DONE WITH DICE")
			DONE_WITH_DICE = false
			WAITING_FOR_DICE = false
			
			if YOURTURN == false:
				$AIResultsDelay.start()
				#NOKICKING = true
			else:
				#print ("Start")
				WAITING_FOR_PLAYER = true
				$PlayerResultsDelay.start()
				#NOKICKING = true
			
			
	if DONE && HPCALC == false:
		$results.visible = true
		if enemyResult > alliedResult:
			$results.text = "DEFEAT"
			get_node("/root/Global").alliedHP -= 2
			get_node("/root/Global").enemyHP -= 1
			alliedDamageDealt = -2
			enemyDamageDealt = -1
			if enemyResult > (alliedResult + 5):
				$results.text = "TOTAL DEFEAT"
				get_node("/root/Global").alliedHP -= 1
				alliedDamageDealt -= 1
			elif enemyResult <= alliedResult + 3:
				$results.text = "NARROW DEFEAT"
				get_node("/root/Global").alliedHP += 1
				get_node("/root/Global").enemyHP += 1
				alliedDamageDealt += 1
				enemyDamageDealt += 1

		elif enemyResult < alliedResult:
			$results.text = "VICTORY"
			get_node("/root/Global").enemyHP -= 2
			get_node("/root/Global").alliedHP -= 1
			enemyDamageDealt = -2
			alliedDamageDealt = -1
			if alliedResult > (enemyResult + 5):
				$results.text = "TOTAL VICTORY"
				get_node("/root/Global").enemyHP -= 1
				enemyDamageDealt -= 1
			elif alliedResult <= enemyResult + 3:
				$results.text = "NARROW VICTORY"
				get_node("/root/Global").enemyHP += 1
				get_node("/root/Global").alliedHP += 1
				alliedDamageDealt += 1
				enemyDamageDealt += 1
		else:
			$results.text = "TIE"
			alliedDamageDealt = 0
			enemyDamageDealt = 0
		HPCALC = true
		
		for aDmg in abs(alliedDamageDealt):
			print (aDmg, "al")
			flashDamage("damage" + String(aDmg+1))
		for eDmg in abs(enemyDamageDealt):
			print (eDmg, "em")
			flashDamage("damage" + String(eDmg+4))
		
		$alliedHP.text = "Allied HP:" + String(get_node("/root/Global").alliedHP)
		$enemyHP.text = "Enemy HP:" + String(get_node("/root/Global").enemyHP)
		if get_node("/root/Global").enemyHP > 0 && get_node("/root/Global").alliedHP > 0:
			$returnmap.text = "Hit CTRL to run the next round of combat"
			
	
	if YOURTURN == false:
		$EnemyTurn.visible = true
		$YourTurn.visible = false
		if enemyDice > 0 && DONE == false:
			$DiceDelay.start()
			$Camera.spawnDice(false)
			enemyDice -= 1
	else:
		$EnemyTurn.visible = false
		$YourTurn.visible = true


	$Label.text = "Total Dice Roll : " + String(diceTotal)
	$charge.text = String(round(kickCharge))
	
	if kickCharging:
		kickCharge += 0.2
		$progressBar.scale.x += 0.01
		
	if shake > 0:
		#print ("shaking")
		shake -= 0.01
		get_node("Camera").setOffset(shake)
	elif shake < 0:
		shake = 0
		#print ("reset")
		get_node("Camera").setOffset(0)
		


func _input(event):
	if event.is_action_pressed("kick") && WAITING_FOR_PLAYER == false && NOKICKING == false && DONE == false:
		if get_node("/root/Global").difficulty == "easy":
			kickCharging = true
		elif get_node("/root/Global").difficulty == "med":
			if kicked == false:
				kickCharging = true
		elif get_node("/root/Global").difficulty == "hard":
			if get_node("/root/Global").kickedEngagement == false:
				kickCharging = true
		elif get_node("/root/Global").difficulty == "insane":
			if get_node("/root/Global").kickedBattle == false:
				kickCharging = true
		$AIResultsDelay.stop()
		WAITING_FOR_DICE = true
		
		
	elif event.is_action_pressed("kick") && NOKICKING == true:
		$noKick.visible = true
	
	elif event.is_action_released("kick") && WAITING_FOR_PLAYER == false && NOKICKING == false && DONE == false:
		if kickCharging == true:
			$AIResultsDelay.stop()
			WAITING_FOR_DICE = true
			for die in get_tree().get_nodes_in_group("dice"):
				die.kick(kickCharge)
			kickCharging = false
			shake = kickCharge * 0.05
			kickCharge = 0
			dice = get_tree().get_nodes_in_group("dice")
			diceTotal = 0
			$progressBar.scale.x = 0
			if get_node("/root/Global").difficulty == "easy":
				print ("easy")
				pass
			elif get_node("/root/Global").difficulty == "med":
				print ("med")
				kicked = true
				$kick.modulate = $kick.modulate * 0.5
			elif get_node("/root/Global").difficulty == "hard":
				print ("hard")
				get_node("/root/Global").kickedEngagement = true
				kicked = true
				$kick.modulate = $kick.modulate * 0.5
			elif get_node("/root/Global").difficulty == "insane":
				print ("insane")
				get_node("/root/Global").kickedBattle = true
				kicked = true
				$kick.modulate = $kick.modulate * 0.5
				
	elif event.is_action_released("kick") && NOKICKING == true:
		$noKick.visible = true
		$progressBar.scale.x = 0
		kickCharge = 0
		kickCharging = false
	
	elif event.is_action_pressed("Ctrl") && DONE:
		if get_node("/root/Global").enemyHP > 0 && get_node("/root/Global").alliedHP > 0:
			get_tree().change_scene("res://Scenes/Spatial.tscn")
		elif get_node("/root/Global").level == 1:
			get_tree().change_scene("res://Scenes/Level1.tscn")
		elif get_node("/root/Global").level == 2:
			get_tree().change_scene("res://Scenes/Level2.tscn")
		elif get_node("/root/Global").level == 3:
			get_tree().change_scene("res://Scenes/Level3.tscn")




func _on_DiceDelay_timeout():
	if enemyDice > 0:
		$DiceDelay.start()
		$Camera.spawnDice(false)
		enemyDice -= 1
	else:
		WAITING_FOR_DICE = true


func _on_AIResultsDelay_timeout():
	$enemyValue.text = "Enemy Score: " + String(diceTotal)
	enemyResult = diceTotal
	YOURTURN = true
	$noKick.visible = false
	$progressBar.scale.x = 0
	for die in get_tree().get_nodes_in_group("dice"):
		dice.erase(die)
		die.queue_free()
	diceTotal = 0
	NOKICKING = false


func _on_PlayerResultsDelay_timeout():
	WAITING_FOR_DICE = false
	$alliedValue.text = "Allied Score: " + String(diceTotal)
	$returnmap.visible = true
	alliedResult = diceTotal
	DONE = true
	if kicked == false:
		$noKick.visible = false
	$progressBar.scale.x = 0
	for die in get_tree().get_nodes_in_group("dice"):
		dice.erase(die)
		die.queue_free()
	diceTotal = 0
	WAITING_FOR_PLAYER = false
	NOKICKING = false



func flashDamage(damageName):
	if has_node(damageName):
		damagesActive.append(damageName)
		get_node(damageName).visible = true
