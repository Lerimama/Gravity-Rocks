extends Node2D

var hajskor = 0
var drugi = 0
var tretji = 0
var cetrti = 0
var peti = 0

onready var sound_nazaj: AudioStreamPlayer = $nazaj


func _ready() -> void:
	
	modulate.a = 0
	
	load_game()
	hajskor = hajskor
	drugi = drugi
	tretji = tretji
	cetrti = cetrti
	peti = peti
	
	$prvi.text = str(hajskor) + " rocks"
	$drugi.text = str(drugi) + " rocks"
	$tretji.text = str(tretji) + " rocks"
	$cetrti.text = str(cetrti) + " rocks"
	$peti.text = str(peti) + " rocks"
	#	$CanvasLayer/prvi.text = "1. " + str(hajskor) + " rocks destroyed"
	#	$CanvasLayer/drugi.text = "2. " + str(drugi) + " rocks destroyed"
	#	$CanvasLayer/tretji.text = "3. " + str(tretji) + " rocks destroyed"
	#	$CanvasLayer/cetrti.text = "4. " + str(cetrti) + " rocks destroyed"
	#	$CanvasLayer/peti.text = "5. " + str(peti) + " rocks destroyed"
	

	hasjkors_in()
		
		
func hasjkors_in():
	
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate:a", 1, 0.5)
	yield(fade_tween, "finished")	
	
	$BtnContainer/BackBtn.grab_focus()
	
	
func hasjkors_out():
	
	$nazaj.play()
	
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	
	get_tree().change_scene("res://scenes/Meni.tscn")
	
		
func load_game():
	
	var save_game = File.new() # nardi nov filet
	if not save_game.file_exists("user://savegame.txt"): # preveri, če filet obstaja
		# print("ni fileta")
		return # cancel all and return to start
	save_game.open("user://savegame.txt", File.READ) # preberi filet
	var current_line = parse_json (save_game.get_line()) # dobi linijo na kateri trenutno smo in jo parsa ...  get save data
	
	hajskor = current_line["hajskor"] # tukaj najde hajskor kluč in ga izpiše
	drugi = current_line["drugi"]
	tretji = current_line["tretji"]
	cetrti = current_line["cetrti"]
	peti = current_line["peti"]
	
	save_game.close()


func _on_BackBtn_button_down() -> void:
	hasjkors_out()


func _on_BackBtn_mouse_entered() -> void:
	$BtnContainer/BackBtn.grab_focus()


func _on_BackBtn_focus_exited() -> void:
	$BtnContainer/Icon.hide()


func _on_BackBtn_focus_entered() -> void:
	$BtnContainer/Icon.show()
