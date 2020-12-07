

	
var name: String
var type: String # inf, veh, art
var HP: int
var maxHP: int
var combats: int
var personality: int

var quips = []

var stats = {
	"Strength": 0,
	"HP": 0,
	"MaxHP": 0,
	"Speed": "",
	"FortBonus": 0,
	"FortSpeed": "",
	"Morale": "",
	"Mobility": "",
	"WeatherResist": "",
	"Reach": "",
	"Special": "",
	"Price": 0
}

var personalities = ["angry", "sassy", "tired", "frustrated", "sad", "optimist", "dumb"]

func _init(newName: String, newType: String):
	randomize()
	self.name = newName
	self.type = newType
	HP = 0
	maxHP = 0
	combats = 0
	personality = randi()%(personalities.size())#rand_range(0, personalities.size())
	genQuips()
	genStats()


func setPersonality(newPerson: String):
	pass



func genStats():
	
	if type == "inf":
		stats.Strength = 3
		stats.HP = 3
		stats.MaxHP = 3
		stats.Speed = "Slow"
		stats.FortBonus = 2
		stats.FortSpeed = "Med"
		stats.Morale = "Low"
		stats.Mobility = "Low"
		stats.WeatherResist = "Med"
		stats.Reach = "Med"
		stats.Price = 3
	elif type == "veh":
		stats.Strength = 5
		stats.HP = 5
		stats.MaxHP = 5
		stats.Speed = "Fast"
		stats.FortBonus = 0
		stats.FortSpeed = "N/A"
		stats.Morale = "Med"
		stats.Mobility = "High"
		stats.WeatherResist = "Low"
		stats.Reach = "Long"
		stats.Price = 6
	elif type == "art":
		stats.Strength = 1
		stats.HP = 3
		stats.MaxHP = 3
		stats.Speed = "V. Slow"
		stats.FortBonus = 7
		stats.FortSpeed = "Slow"
		stats.Morale = "Low"
		stats.Mobility = "V. Low"
		stats.WeatherResist = "Low"
		stats.Reach = "V. Long"
		stats.Price = 7
		stats.Special = "Artillery"
	elif type == "sni":
		stats.Strength = 0
		stats.HP = 2
		stats.MaxHP = 2
		stats.Speed = "V. Slow"
		stats.FortBonus = 0
		stats.FortSpeed = "V. Slow"
		stats.Morale = "Low"
		stats.Mobility = "V. Low"
		stats.WeatherResist = "Low"
		stats.Reach = "N/A"
		stats.Price = 5
		stats.Special = "Sniper"
	elif type == "bru":
		stats.Strength = 4
		stats.HP = 3
		stats.MaxHP = 3
		stats.Speed = "Med"
		stats.FortBonus = 1
		stats.FortSpeed = "Slow"
		stats.Morale = "High"
		stats.Mobility = "Med"
		stats.WeatherResist = "Med"
		stats.Reach = "Short"
		stats.Price = 4
		stats.Special = "Growth"



func addQuip(quip: String):
	if quip == "":
		pass
	else:
		quips.append(quip)
		#print ("NEW QUIP ADDED: ", quip)


func genQuips():
	#print ("GEN QUIPS")
	var msg
	var mood = personalities[personality]
	quips = []

	if mood == "angry":
		msg = name + " keeps cracking his knuckles while glaring at you."
		addQuip(msg)
		msg = "Everyone tries to avoid " + name + ", he tends to yell a lot."
	elif mood == "sassy":
		msg = name + " is ignoring you."
	elif mood == "tired":
		msg = "There is nothing " + name + " wouldn't do for a nap right now."
		addQuip(msg)
		msg = name + " needs coffee. Right. Now."
	elif mood == "frustrated":
		msg = name + " keeps biting their lip. He's about to punch someone." 
	elif mood == "sad":
		msg = "If anyone needs a hug here, it's " + name + "."
		addQuip(msg)
		msg = name + " thought the military would help with his depression."
	elif mood == "optimist":
		msg = name + " is a weirdo. He's actually happy to be here."
		addQuip(msg)
		msg = name + " tries to keep morale up, even after everyone forgot his birthday."
	elif mood == "dumb":
		msg = name + " didn't pass his entrance exam, but was let in anyways."
		addQuip(msg)
		msg = name + "'s IQ ranks among the single digits, but he can follow orders."
	else:
		msg = "ERR" + name + "-" + String(personality)
	addQuip(msg)
	msg = ""
	
	if type == "inf":
		msg = name + " really wishes he had a car. A really nice car."
		addQuip(msg)
		if mood == "dumb":
			msg = "No one wants to be infantry. Well, except maybe " + name + "."
		else:
			msg = "No one wants to be infantry. Especially not " + name + "."
	elif type == "veh":
		msg = name + " loves the purr of his engine."
	elif type == "art":
		msg = "Don't tell anyone, but " + name + " went deaf years ago."
	addQuip(msg)
	msg = ""
	
	if HP == maxHP:
		msg = name + " is ready for a go."
	elif HP < maxHP && HP != 1:
		msg = name + " took a beating, but could go again."
	else:
		msg = name + " is about to die! Don't send him out again!"
	addQuip(msg)
	msg = ""

	if combats == 0:
		msg = name + " is a little nervous. It's his first time!"
	elif combats > 0 && combats < 3:
		msg = name + " is weary. He's seen some combat."
	else:
		msg = "There is no life in " + name + "'s eyes. They've seen too much."
	addQuip(msg)
	msg = ""

	if type == "art" && (mood == "sad" || mood == "angry"):
		msg = name + " should NOT have an artillery cannon."
	addQuip(msg)
	msg = ""


func getBark():
	randomize()
	var temp = randi()%(quips.size())
	#print (quips.size(), temp, quips)
	return quips[temp]
