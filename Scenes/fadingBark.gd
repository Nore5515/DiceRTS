extends Label


var fadeRate = 0.005


func init(incText):
	text = incText

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a = lerp(modulate.a, 0, fadeRate)
	if modulate.a < 0.6:
		fadeRate = 0.4
	if modulate.a < 0.01:
		queue_free()
