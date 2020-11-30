extends CanvasLayer


export (int) var budget = 10

var priceInf = 2
var priceVeh = 4
var priceArt = 6

var countInf = 0
var countVeh = 0
var countArt = 0

var totalInfPrice = 0
var totalVehPrice = 0
var totalArtPrice = 0

var total = 0


func _process(delta):
	
	if $TextBudget.text != String(budget):
		$TextBudget.text = String(budget)

	if $TextInf.text != String(countInf):
		$TextInf.text = String(countInf)
	if $TextVeh.text != String(countVeh):
		$TextVeh.text = String(countVeh)
	if $TextArt.text != String(countArt):
		$TextArt.text = String(countArt)
	
	if $TextInfPrice.text != String(totalInfPrice):
		$TextInfPrice.text = String(totalInfPrice)
	if $TextVehPrice.text != String(totalVehPrice):
		$TextVehPrice.text = String(totalVehPrice)
	if $TextArtPrice.text != String(totalArtPrice):
		$TextArtPrice.text = String(totalArtPrice)
	
	if $TextTotal.text != String(total):
		$TextTotal.text = String(total)

	if total != (budget - (totalInfPrice+totalVehPrice+totalArtPrice)):
		total = (budget - (totalInfPrice+totalVehPrice+totalArtPrice))
	
	if totalInfPrice != countInf * priceInf:
		totalInfPrice = countInf * priceInf
	if totalVehPrice != countVeh * priceVeh:
		totalVehPrice = countVeh * priceVeh
	if totalArtPrice != countArt * priceArt:
		totalArtPrice = countArt * priceArt


func _on_minusInf_pressed():
	if countInf > 0:
		countInf -= 1
func _on_plusInf_pressed():
	if countInf < 9:
		countInf += 1


func _on_minusVeh_pressed():
	if countVeh > 0:
		countVeh -= 1
func _on_plusVeh_pressed():
	if countVeh < 9:
		countVeh += 1


func _on_minusArt_pressed():
	if countArt > 0:
		countArt -= 1
func _on_plusArt_pressed():
	if countArt < 9:
		countArt += 1


func _on_Button_pressed():
	if total >= 0:
		var global = get_node("/root/Global")
		global.infCount = countInf
		global.vehCount = countVeh
		global.artCount = countArt
		if get_parent().has_node("PlacementBox"):
			get_parent().get_node("PlacementBox").visible = true
			get_parent().get_node("PlacementBox").makeVisible()
		queue_free()
