extends Control


onready var continue_btn: Button = $BtnContainerContinue/ContinueBtn
onready var play_btn: Button = $BtnContainer/PlayBtn
onready var quit_btn: Button = $BtnContainer2/QuitBtn
onready var exit_btn: Button = $BtnContainer3/ExitBtn


func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_released("ui_cancel"):
		get_tree().paused  = not get_tree().is_paused()
		
		if get_tree().paused:
			get_parent().sound_nazaj.play()
			pause_game()
		else: 
			continue_game()

	
	
	
func _ready() -> void:
	
	hide()
	modulate.a = 0
	
	
func pause_game():

	show()

	var fade_tween = get_tree().create_tween().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	fade_tween.tween_property(self, "modulate:a", 1, 0.5)
	yield(fade_tween, "finished")	
	continue_btn.grab_focus()
	
	
func continue_game(): 

	get_parent().sound_naprej.play()
	
	var fade_tween = get_tree().create_tween().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	fade_tween.tween_property(self, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")	
	
	get_tree().paused = false


func _on_PavzaBtn_button_down() -> void:
	continue_game()


func _on_PavzaBtn_focus_entered() -> void:
	continue_btn.get_parent().get_node("Icon").show()

func _on_PavzaBtn_focus_exited() -> void:
	continue_btn.get_parent().get_node("Icon").hide()

func _on_PavzaBtn_mouse_entered() -> void:
	continue_btn.grab_focus()

# FOCUS ... na button_down je v HUD.gd



func _on_PlayBtn_button_down() -> void:

	get_parent().sound_nazaj.play()
	
	var fade_tween = get_tree().create_tween().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	fade_tween.tween_property(get_parent().get_parent(), "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(get_parent().game_over, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(self, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(get_parent().game_hud, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().paused = false
	
	get_tree().reload_current_scene()


func _on_QuitBtn_button_down() -> void:
	
	get_parent().sound_nazaj.play()
	
	var fade_tween = get_tree().create_tween().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	fade_tween.tween_property(get_parent(), "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(get_parent().get_parent(), "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(get_parent().game_over, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(self, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(get_parent().game_hud, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().paused = false
	
	get_tree().change_scene("res://scenes/Meni.tscn")


func _on_ExitBtn_button_down() -> void:
	
	get_parent().sound_nazaj.play()
	
	var fade_tween = get_tree().create_tween().set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	fade_tween.tween_property(get_parent().get_parent(), "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(get_parent().game_over, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(self, "modulate:a", 0, 0.5)
	fade_tween.parallel().tween_property(get_parent().game_hud, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().paused = false
	
	get_tree().quit()



func _on_PlayBtn_focus_entered() -> void:
	
	get_parent().sound_fokus.play()
	play_btn.get_parent().get_node("Icon").show()


func _on_PlayBtn_focus_exited() -> void:
	play_btn.get_parent().get_node("Icon").hide()


func _on_PlayBtn_mouse_entered() -> void:
	play_btn.grab_focus()


func _on_QuitBtn_focus_entered() -> void:
	
	get_parent().sound_fokus.play()
	quit_btn.get_parent().get_node("Icon").show()


func _on_QuitBtn_focus_exited() -> void:
	quit_btn.get_parent().get_node("Icon").hide()


func _on_QuitBtn_mouse_entered() -> void:
	quit_btn.grab_focus()


func _on_ExitBtn_focus_entered() -> void:

	get_parent().sound_fokus.play()
	exit_btn.get_parent().get_node("Icon").show()


func _on_ExitBtn_focus_exited() -> void:
	exit_btn.get_parent().get_node("Icon").hide()


func _on_ExitBtn_mouse_entered() -> void:
	exit_btn.grab_focus()

