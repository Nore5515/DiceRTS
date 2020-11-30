extends Sprite

var isInf = false
var isVeh = false
var isArt = false



func save():
	var data = {
		"global_position": global_position,
		"isInf": isInf,
		"isVeh": isVeh,
		"isArt": isArt,
	}
	return data
	

func loadCorpse(data):
	global_position = data["global_position"]
	setInf(data["isInf"], data["isVeh"], data["isArt"])



func setInf(isInf, isVeh, isArt):
	if isInf:
		$inf.visible = true
		isInf = true
	elif isVeh:
		$veh.visible = true
		isVeh = true
	elif isArt:
		$art.visible = true
		isArt = true
