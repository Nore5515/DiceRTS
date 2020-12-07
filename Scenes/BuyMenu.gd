extends Control



var personalityList
# ISNT ACTUALLY INT IS STRING THAT DESCRIBES IT
var personalityNum
var corruption = 0
var corrupted = false
var unitTypeSet = ""

var fadingFunds = false
var fadingPick = false
var fadingCorruption = false

func _on_DoneButton_pressed():
	visible = false



func _ready():
	randomize()
	var temp = load("res://Assets/Classes/Unit.gd").new("Boo", "inf")
	personalityList = temp.personalities
	clear()


func _process(delta):
	if visible:
		$Funds.text = String(get_node("/root/Global").budget)
		
		if fadingFunds:
			$NotEnoughFunds.modulate.a = lerp($NotEnoughFunds.modulate.a, 0, 0.05)
			if $NotEnoughFunds.modulate.a <= 0.01:
				fadingFunds = false
				$NotEnoughFunds.modulate.a = 0
		if fadingPick:
			$PickAChoice.modulate.a = lerp($PickAChoice.modulate.a, 0, 0.05)
			if $PickAChoice.modulate.a <= 0.01:
				fadingPick = false
				$PickAChoice.modulate.a = 0
		if fadingCorruption:
			$CantDoCorrupt.modulate.a = lerp($CantDoCorrupt.modulate.a, 0, 0.05)
			if $CantDoCorrupt.modulate.a <= 0.01:
				fadingPick = false
				$CantDoCorrupt.modulate.a = 0


func _on_InfButton_pressed():
	$UnitIcon.texture = load("res://Assets/Art/inf.png")
	$UnitTitle.text = "INFANTRY"
	$UnitDesc.text = "Cheap, and decent at defending. Expendible and knows it."
	$UnitStats.text = genUnitStats("inf")
	unitTypeSet = "inf"

func _on_VehButton_pressed():
	$UnitIcon.texture = load("res://Assets/Art/vehical.png")
	$UnitTitle.text = "ARMORED VEHICLE"
	$UnitDesc.text = "Pricey, but worth it. Powerful attacker, with decent health, but can't fortify."
	$UnitStats.text = genUnitStats("veh")
	unitTypeSet = "veh"

func _on_ArtButton_pressed():
	$UnitIcon.texture = load("res://Assets/Art/artillery.png")
	$UnitTitle.text = "MOBILE ARTILLERY"
	$UnitDesc.text = "The price of one of these could save a hundred struggling schools. But can schools fire a shell a quarter of the map away?"
	$UnitStats.text = genUnitStats("art")
	unitTypeSet = "art"

func clear():
	$UnitIcon.texture = null
	$UnitTitle.text = ""
	$UnitDesc.text = ""
	$UnitStats.text = ""
	unitTypeSet = ""



func genUnitStats(unitType):
	var msg = ""
	var uni
	var statArray = []
	
	if unitType == "inf":
		uni = load("res://Assets/Classes/Unit.gd").new("Bob", "inf")
		$Price.text = "3"
		for stat in uni.stats:
			statArray.append(stat)
		var count = 0
		for stat in uni.stats.values():
			statArray[count] = String(statArray[count]) + ": " + String(stat) + "\n"
			msg += statArray[count]
			count += 1
		if $Personality.text == "":
			personalityNum = personalityList[randi()%(personalityList.size())]
			$Personality.text = personalityNum
		return msg
	
	elif unitType == "veh":
		uni = load("res://Assets/Classes/Unit.gd").new("Bob", "veh")
		$Price.text = "6"
		for stat in uni.stats:
			statArray.append(stat)
		var count = 0
		for stat in uni.stats.values():
			statArray[count] = String(statArray[count]) + ": " + String(stat) + "\n"
			msg += statArray[count]
			count += 1
		if $Personality.text == "":
			personalityNum = personalityList[randi()%(personalityList.size())]
			$Personality.text = personalityNum
		return msg
	
	elif unitType == "art":
		uni = load("res://Assets/Classes/Unit.gd").new("Bob", "art")
		$Price.text = "7"
		for stat in uni.stats:
			statArray.append(stat)
		var count = 0
		for stat in uni.stats.values():
			statArray[count] = String(statArray[count]) + ": " + String(stat) + "\n"
			msg += statArray[count]
			count += 1
		if $Personality.text == "":
			personalityNum = personalityList[randi()%(personalityList.size())]
			$Personality.text = personalityNum
		return msg
	
	
	return msg



func _on_CycleSoul_pressed():
	var chance = randi()%100
	if chance < corruption:
		$Personality.text = "SOUL CORRUPTED"
		corrupted = true
	else:
		corrupted = false
		corruption += 1
		$Personality.text = personalityList[randi()%(personalityList.size())]


func _on_RecruitButton_pressed():
	if !corrupted:
		if unitTypeSet != "":
			if get_node("/root/Global").budget >= int($Price.text):
				get_node("/root/Global").budget -= int($Price.text)
				print ("TES")
				var global = get_node("/root/Global")
				var unitName = $NameLine.text
				var unitType = unitTypeSet
				
				var unitRef = load("res://Assets/Classes/Unit.gd")
				var newUnit = unitRef.new(unitName, unitType)
				newUnit.setPersonality(personalityNum)
				global.squad.append(newUnit)
				get_parent().get_parent().get_node("ScrollContainer").updateStuff()
				clear()
			else:
				fadingFunds = true
				$NotEnoughFunds.modulate.a = 1
		else:
			fadingPick = true
			$PickAChoice.modulate.a = 1
	else:
		fadingCorruption = true
		$CantDoCorrupt.modulate.a = 1
