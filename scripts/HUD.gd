extends CanvasLayer

signal start_game

func update_tajm(cajt):
	$tajm.text = str(cajt)
	
func show_message(text):
	$gejmover.text = text # nek text pač
	$gejmover.show() # med igro je skrit, na koncu se pokaže
			
	var gejm_hud = get_tree().get_nodes_in_group("VisibleInGame") # zbrišeš vse elemente v grupi kamni 
	for gejm_hud_element in gejm_hud:
		gejm_hud_element.hide()

func show_game_over(): # tole je funkcija, ki deluje v okviru show message
#	$hahaha.play()
	show_message("Game Over")

	var gejmover_hud = get_tree().get_nodes_in_group("VisibleInGameOver") # zbrišeš vse elemente v grupi kamni 
	for gejmover_hud_element in gejmover_hud:
		gejmover_hud_element.show()
	
func _on_igraj_btn_pressed() -> void: #JA
	get_tree().reload_current_scene()
	
func _on_neigraj_btn_pressed() -> void: # NE
	get_tree().change_scene("res://scenes/Meni.tscn")

