extends Node2D

var hajskor = 0
var drugi = 0
var tretji = 0
var cetrti = 0
var peti = 0

func _ready() -> void:

	load_game()
	
	hajskor = hajskor
	drugi = drugi
	tretji = tretji
	cetrti = cetrti
	peti = peti
	
	$CanvasLayer/prvi.text = "1. mesto: " + str(hajskor)
	$CanvasLayer/drugi.text = "2. mesto: " + str(drugi)
	$CanvasLayer/tretji.text = "3. mesto: " + str(tretji)
	$CanvasLayer/cetrti.text = "4. mesto: " + str(cetrti)
	$CanvasLayer/peti.text = "5. mesto: " + str(peti)

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		get_tree().change_scene("res://scenes/Meni.tscn")
	
func load_game():
	var save_game = File.new() # nardi nov filet
	if not save_game.file_exists("user://savegame.txt"): # preveri, če filet obstaja
		print("ni fileta")
		return # cancel all and return to start
	save_game.open("user://savegame.txt", File.READ) # preberi filet
	var current_line = parse_json (save_game.get_line()) # dobi linijo na kateri trenutno smo in jo parsa ...  get save data
	
	hajskor = current_line["hajskor"] # tukaj najde hajskor kluč in ga izpiše
	drugi = current_line["drugi"]
	tretji = current_line["tretji"]
	cetrti = current_line["cetrti"]
	peti = current_line["peti"]
	
	save_game.close()
	
	
