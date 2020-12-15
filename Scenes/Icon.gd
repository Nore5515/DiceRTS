extends Node2D



export (String) var type
export (Color) var color


func _ready():
	$TeamSpray.modulate = color
	setPic(type)

		
func setPic(typeOfUnit):
	if typeOfUnit == "Inf":
		$Base.texture = load("res://Assets/Art/newstuff/icons/soldierFace.png")
		$TeamSpray.texture = load("res://Assets/Art/newstuff/icons/soldierFace_TEAM.png")

	elif typeOfUnit == "veh":
		$Base.texture = load("res://Assets/Art/newstuff/icons/veh.png")
		$TeamSpray.texture = load("res://Assets/Art/newstuff/icons/veh_TEAM.png")
	
	elif typeOfUnit == "art_cannon":
		$Base.texture = load("res://Assets/Art/newstuff/icons/artCannon.png")
		$TeamSpray.texture = load("res://Assets/Art/newstuff/icons/artCannon_TEAM.png")
	
	elif typeOfUnit == "art_off_guard":
		$Base.texture = load("res://Assets/Art/newstuff/icons/artOffGuard.png")
		$TeamSpray.texture = load("res://Assets/Art/newstuff/icons/artOffGuard_TEAM.png")
	
	else:
		print ("ERROR\t", typeOfUnit)
		setPic("art_cannon")
