extends Node2D


#get_node("/root/Global")


var playerTeam
var playerColor

var badteam
var badColor

var unitNames = []
var unitPos = []
var unitSlowed = []
var unitMegaSlowed = []

var unitHP = []

var alliedName = ""
var alliedDice = -1
var enemyName = ""
var enemyDice = -1

var alliedHP = -1
var enemyHP = -1

var defenderAllied = false
var defenderEnemy = false

var temp = -1


var level = 1

var deadSpots = []
var deadNames = []

var unitsFortified = []

var enemiesEngaged = []
var detectorUnit

################

var infCount = 1
var vehCount = 0
var artCount = 0

var boughtUnits = []

#get_node("/root/Global")

var difficulty = "med"
var kickedEngagement = false
var kickedBattle = false

var alliedTag
var enemyTag

var allUnits = []
var unitTags = []

var corpses = []

var beat1 = true
var beat2 = true
var beat3 = true
var beatOptional = false
var beatCheckpoint = false

var availableLevels = []

var budget = 20

var squad = []

var localSquad = []

var init

const UnitClass = preload("res://Assets/Classes/Unit.gd")

var sceneUnits = []

var attackingUnit: UnitClass
var defendingUnit: UnitClass


func _process(delta):
	if temp != alliedDice:
		print ("allied dice changed from ", temp, " to ", alliedDice)
	temp = alliedDice


func increaseVolume():
	$AudioStreamPlayer2D.volume_db += 1

func decreaseVolume():
	$AudioStreamPlayer2D.volume_db -= 1



func endMusic():
	$AudioStreamPlayer2D.queue_free()

func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
