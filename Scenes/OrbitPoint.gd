extends Spatial


var stars = []

var minX = -300
var minY = -300
var minZ = -300

var maxX = 600
var maxY = 600
var maxZ = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	var starClusters = 50#randi()%20
	var instance
	var randX
	var randY
	var randZ
	for x in starClusters:
		randX = randi() % maxX + minX
		randY = randi() % maxY + minY
		randZ = randi() % maxZ + minZ
		#print (randX, randY, randZ)
		instance = load("res://Scenes/stars.tscn").instance()
		add_child(instance)
		instance.transform.origin = Vector3(randX,randY,randZ)
		instance.look_at(transform.origin, Vector3(0,1,0))


func _process(delta):
	rotate(Vector3(0,1,0), 0.0005)
