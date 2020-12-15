extends Spatial


onready var above_head = self.global_transform.origin
onready var label = get_parent().get_node("CanvasLayer/AIText")
onready var camera = get_parent().get_node("CameraRig/ClippedCamera")

onready var offset = Vector2(label.get_size().x/2, 0)

var painted = false

var levelDialoguePriority = false
var levelDialogue = [
	["EntryPoint", "green", "You did it! First steps!"],
	["Ambush", "red", "Drat. Thought that would work."],
	["Cache", "yellow", "Nooooooo! My supplies!"],
	["Checkpoint", "blue", "I spent two hours designing that..."],
	["Siege", "green", "You did it! You beat the game! Congratulations! c:"]
	
]

var dialogueQueue = []
var dialogue = [
	["green", "How's it going?"],
	["cyan", "No rush. We're not going anywhere."],
	["green", "Technically it's your turn.",
		"green", "But then again it's ALWAYS your turn, so..."
	],
	["white", "I think multiplayer is coming soon..."],
	["blue", "I miss home."],
	["cyan", "The stars are...interesting. Could be better.",
		"cyan", "Then again what do I know?"
	],
	["red", "I don't like it when I lose."],
	["blue", "Sometimes I get attatched to a guy.", "blue", "Then he dies."],
	["green", "Wanna hear a joke?", "blue", "Yeah, me too..."],
	["green", "Wanna hear a joke?", 
		"green", "What do you call a fly with no legs...?",
		"red", "A cripple! HAHAHAHAHAHA"
	],
	["green", "Wanna hear a joke?", 
		"green", "What do you call a fly with no legs...?",
		"green", "A walk! c:"
	],
	["green", "I'm very excited to play with you!",
		"yellow", "UHHHH...don't take that the wrong way please!"
	]
]


func _ready():
	randomize()
	above_head.y += 4
	label.rect_position = (camera.unproject_position(above_head) - offset)
	$Timer3.start()
	$fadeTimer.start()


var time = 0

func _process(delta):
	translate(Vector3(0,sin(time) * 0.01,0))
	time += delta * 5
	label.rect_position = (camera.unproject_position(above_head) - offset)
	look_at(get_parent().get_node("CameraRig/ClippedCamera").global_transform.origin, Vector3(0,1,0))


func fillQueue():
	dialogueQueue = dialogue[randi()%(dialogue.size()-1)]


func paintColor(incomingColor: String):
	if incomingColor == "blue":
		$head.get_surface_material(0).albedo_color = Color.blue
	elif incomingColor == "white":
		$head.get_surface_material(0).albedo_color = Color.white
	elif incomingColor == "cyan":
		$head.get_surface_material(0).albedo_color = Color.cyan
	elif incomingColor == "green":
		$head.get_surface_material(0).albedo_color = Color.green
	elif incomingColor == "red":
		$head.get_surface_material(0).albedo_color = Color.red
	elif incomingColor == "yellow":
		$head.get_surface_material(0).albedo_color = Color.yellow
	dialogueQueue.pop_front()
	painted = true


func fillQueueLevel():
	dialogueQueue = dialogue[randi()%(dialogue.size()-1)]
	pass


func _on_Timer3_timeout():
	
	if get_parent().get_node("CanvasLayer/LoadingScreen").is_playing() == false:
		
		if levelDialoguePriority:
			fillQueueLevel()
		
		if get_parent().get_node("CameraRig/ClippedCamera").global_transform.origin.distance_to(self.global_transform.origin) < 6:
			dialogueQueue = ["yellow", "You're, uh, very close..."]
		if get_parent().get_node("CameraRig/ClippedCamera").global_transform.origin.distance_to(self.global_transform.origin) > 35:
			dialogueQueue = ["blue", "Why are you so far away?"]
		if dialogueQueue.size() > 0:
			print (dialogueQueue)
			if painted == false:
				paintColor(dialogueQueue[0])
			label.text = dialogueQueue[0]
			offset = Vector2(label.get_size().x/2, 0)
			dialogueQueue.pop_front()
		else:
			fillQueue()
		$Timer3.wait_time = rand_range(3,5)
		$Timer3.start()
		$fadeTimer.start()


func _on_fadeTimer_timeout():
	label.text = ""
	$head.get_surface_material(0).albedo_color = Color.white
	painted = false
