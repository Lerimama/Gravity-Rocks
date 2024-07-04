extends CanvasLayer


onready var game_hud: Control = $Game
onready var game_over: Control = $GameOver
onready var gejmover_title: Label = $GameOver/gejmover
onready var pavza: Control = $Pavza

onready var play_btn: Button = $GameOver/BtnContainer/PlayBtn
onready var quit_btn: Button = $GameOver/BtnContainer2/QuitBtn
onready var exit_btn: Button = $GameOver/BtnContainer3/ExitBtn

onready var sound_naprej: AudioStreamPlayer = $naprej
onready var sound_nazaj: AudioStreamPlayer = $nazaj
onready var sound_fokus: AudioStreamPlayer = $fokus
		
		
func _ready() -> void:
	
	game_over.hide()
	# pavza skrije sebe
	
func update_tajm_text(cajt):
	
	$Game/tajm.text = "%ss" % str(cajt)


func show_game_over(player_rank: int, player_score: int): # tole je funkcija, ki deluje v okviru show message
	
	var score_label: Label = $GameOver/rezultat
	if player_rank == 1:
		score_label.text = "Congratulations! You destroyed %s rocks. " % str(player_score) + " and set the new record!"
		gejmover_title.modulate = Color.yellow
		score_label.modulate = Color.yellow
	elif player_rank <= 5 and not player_rank == 0:
		score_label.text = "You destroyed %s rocks. " % str(player_score)
		match player_rank:
			2: score_label.text += "Your score ranks 2nd among the all-time best."
			3: score_label.text += "Your score ranks 3rd among the all-time best."
			4: score_label.text += "Your score ranks 4th among the all-time best."
			5: score_label.text += "Your score ranks 5th among the all-time best."
		gejmover_title.modulate = Color.red
		score_label.modulate = Color.red
	else:
		gejmover_title.modulate = Color.red
		score_label.modulate = Color.red
		score_label.text = "You destroyed %s rocks." % str(player_score)
		
	yield(get_tree().create_timer(0.5), "timeout")
	
	if player_rank == 1:
		$"../zdravljica".play()
	else:
		$"../hahaha".play()	
		
	game_over.modulate.a = 0
	game_over.show()
	
	play_btn.grab_focus()	
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(game_hud, "modulate:a", 0, 0.5)
	fade_tween.tween_property(game_over, "modulate:a", 1, 0.7)
	
	# razrdečim kamne in redzone
	fade_tween.parallel().tween_property(get_parent().get_node("redzone"), "modulate:a", 0, 1)
	for kamn in get_tree().get_nodes_in_group("kamni"):
		fade_tween.parallel().tween_property(kamn, "modulate", Color.white, 1)
	yield(fade_tween, "finished")	
	game_hud.hide()
	get_parent().get_node("redzone").hide()
	

func _on_PlayBtn_button_down() -> void:
	
	sound_naprej.play()
	
	var fade_tween = get_tree().create_tween().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	fade_tween.tween_property(get_parent(), "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(game_over, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(pavza, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(game_hud, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().reload_current_scene()


func _on_QuitBtn_button_down() -> void:
	
	sound_nazaj.play()
	
	var fade_tween = get_tree().create_tween().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	fade_tween.tween_property(get_parent(), "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(game_over, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(pavza, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(game_hud, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().change_scene("res://scenes/Meni.tscn")


func _on_ExitBtn_button_down() -> void:
	
	sound_nazaj.play()
	
	var fade_tween = get_tree().create_tween().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	fade_tween.tween_property(get_parent(), "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(game_over, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(pavza, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(game_hud, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().quit()


# BTN FOCUS


func _on_PlayBtn_focus_entered() -> void:
	
	sound_fokus.play()
	play_btn.get_parent().get_node("Icon").show()

func _on_PlayBtn_focus_exited() -> void:
	
	play_btn.get_parent().get_node("Icon").hide()

func _on_PlayBtn_mouse_entered() -> void:
	
	play_btn.grab_focus()


func _on_QuitBtn_focus_entered() -> void:

	sound_fokus.play()
	quit_btn.get_parent().get_node("Icon").show()

func _on_QuitBtn_focus_exited() -> void:
	quit_btn.get_parent().get_node("Icon").hide()

func _on_QuitBtn_mouse_entered() -> void:
	quit_btn.grab_focus()

func _on_ExitBtn_focus_entered() -> void:
	
	sound_fokus.play()
	exit_btn.get_parent().get_node("Icon").show()

func _on_ExitBtn_focus_exited() -> void:
	exit_btn.get_parent().get_node("Icon").hide()

func _on_ExitBtn_mouse_entered() -> void:
	exit_btn.grab_focus()
