extends Node2D


export var num_kamen = 0 # začetno število kamnov
export var ekstra_num_kamen = 1 # vsako naslednje število kamnov

var ostanek_kamnov = 0
var serija = 1
var def_pozicija = Vector2(640, 360)
var mali_follow : bool = false
var shield_time: float = 3

var runda_cajt = 0
var cajt = 1 # čas do deathmodeta
var cajt_vecanje = 5 # vsak spawn se poveča za ...

# player 1
var player_score = 0
var player_life = 3 # debug

var hajskor = 0
var sejvan_hajskor : int

var drugi = 0
var tretji = 0
var cetrti = 0
var peti = 0

var red_mode: bool = false
var round_spawned: bool
var red_mode_speed_adon: float = 0.01

onready var kamen = preload("res://scenes/Kamn.tscn") # preload vzame katerokoli sceno ... dobro da smo organizirali že prej
onready var metk = preload("res://scenes/Metk.tscn")
onready var mali_kamn = preload("res://scenes/Mali_kamn.tscn")
onready var player_p1 = preload("res://scenes/Player.tscn")
onready var explozija_rakete = preload ("res://scenes/particles/explozija_rakete.tscn")
onready var eksplozija_metka = preload("res://scenes/particles/explozija_metka.tscn")

var game_is_over: bool = false


func _input(event: InputEvent) -> void:
		
	if Input.is_action_just_released("mute"):
		if $muzika.get_stream_paused() == true:
			$muzika.set_stream_paused(false)
		else:
			$muzika.set_stream_paused(true)
			
		
func _ready() -> void:
	
	modulate.a = 0
	$redzone.hide()
	$HUD.game_hud.modulate.a = 0
	
	load_game()
	hajskor = hajskor
	drugi = drugi
	tretji = tretji
	cetrti = cetrti
	peti = peti
	
	$HUD/Game/rekord.text %= str(hajskor)
	$HUD/Game/tajm.text = "%ss" % str(cajt)
	$HUD/Game/lajf_p1.text = str(player_life)
	$HUD/Game/serija_kamnov.text = "%d" % serija
	
	$Player.position = def_pozicija
	$Player.rotation = 0
	$Player.show()
	$Player.shield_status = 1
	
	cajt = runda_cajt
	
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate:a", 1, 0.5)
	fade_tween.parallel().tween_property($HUD.game_hud, "modulate:a", 1, 0.5)
	yield(fade_tween, "finished")	
	
	game_start()


func _process(delta: float) -> void:
	
	if game_is_over:
		return
		
	if $Player.is_visible():
		if Input.is_action_just_pressed("shoot"):
			var nov_metk = metk.instance()
			nov_metk.position = $Player.position
			nov_metk.rotation = $Player.rotation
			nov_metk.connect("metek_zadetek", self, "_on_metek_zadetek")
			add_child(nov_metk)
			$laser.play()

	# NOV LEVEL ... to je tukaj ker na koncu ostanejo kamenčki
	if ostanek_kamnov == 0: 
		on_new_level()
	
	if cajt == 0: # FOLLOW MODE
		if not red_mode:
			red_mode = true
			on_red_mode_start()
	else:
		red_mode = false
		$HUD/Game/tajm.modulate = Color.white
		#	if red_mode:
		#		for mali_kamn in get_tree().get_nodes_in_group("mali_kamni") :
		#			mali_kamn.modulate = Color.red
		#			if mali_follow == true: 
		##				mali_kamn.velocity = mali_kamn.global_position.direction_to($Player.global_position)
		##				mali_kamn.global_position = mali_kamn.velocity * 0.8 # delta * 70		
		#				mali_kamn.velocity = mali_kamn.velocity * 1.2#delta * 70		


func game_start():
	
	$Player/ShieldTime.start(shield_time)
	$deathmode.start(1)
	
	var current_muza_volume: float = $muzika.get_volume_db()
	$muzika.set_volume_db(-80)
	$muzika.play()
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property($muzika, "volume_db", current_muza_volume, 0.1)
	yield(fade_tween, "finished")	
	

func game_over():
	
	game_is_over = true

	# pospravi	
	for timer in [$novlajf_timer, $deathmode, $mali_deathmode]:
		timer.stop()

	$Player.call_deferred("queue_free")
	
	# GO ekran
	var player_rank: int = get_player_rank()
	
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property($muzika, "volume_db", -80, 1)
	yield(fade_tween, "finished")	
	$muzika.stop()	
	
	$HUD.show_game_over(player_rank, player_score)

	
func on_new_level():
	
	num_kamen += ekstra_num_kamen # št. dodatnih kamnov
	runda_cajt += cajt_vecanje * serija
	cajt = runda_cajt
	
	spawn_kamnov()	
	$HUD/Game/serija_kamnov.text = "%d" % serija	
	serija += 1
	
	for malikamn in get_tree().get_nodes_in_group("mali_kamni"): # zazih
		malikamn.follow_speed_adon = 0
	
	$HUD.update_tajm_text(cajt)
	$deathmode.start(1)
	$redzone.hide()
	
	
func on_red_mode_start():
		
	$deathmode.stop()
	$HUD/Game/tajm.text = "RED MODE"
	$HUD/Game/tajm.modulate = Color.red
	$redzone.show()
	
	# kamni follow
	var vsi_kamni = get_tree().get_nodes_in_group("veliki_kamni") 
	# veliki eksplodirajo v male
	$eksplozija_mali_kamn.play()
	$Kamera.tresi()
	$mali_deathmode.start()
	for kamn in vsi_kamni:
		ostanek_kamnov -= 1
		for _i in range(3):
			var nov_mali_kamn = mali_kamn.instance()
			nov_mali_kamn.position = kamn.global_position
			add_child(nov_mali_kamn)
			nov_mali_kamn.connect("mali_kamn_dest", self, "_on_mali_kamn_dest")
			
			ostanek_kamnov += 1 
		kamn.queue_free()
		
	for malikamn in get_tree().get_nodes_in_group("mali_kamni") :
		malikamn.modulate = Color.red
		malikamn.follow_speed_adon = 0.007

		
func _on_metek_zadetek(pozicija, rotacija):
	
	$metek_zadetek.play()
	
	var nova_eksplozija_metka = eksplozija_metka.instance()
	nova_eksplozija_metka.position = pozicija
	nova_eksplozija_metka.rotation = rotacija - 3.75
	nova_eksplozija_metka.set_emitting(true)
	add_child(nova_eksplozija_metka)
	

func _on_kamn_dest(poz): # vzame spemenljivko POZ in ji da argument, ki je poslan
	
	$eksplozija_mali_kamn.play()
	
	player_score += 1
	$HUD/Game/score_p1.text = str(player_score)	
	$Kamera.tresi()
	ostanek_kamnov -= 1
	
	for _i in range(3):
		var nov_mali_kamn = mali_kamn.instance()
		nov_mali_kamn.position = poz
		add_child(nov_mali_kamn)
		nov_mali_kamn.connect("mali_kamn_dest", self, "_on_mali_kamn_dest")
		ostanek_kamnov += 1 
		
		
func _on_mali_kamn_dest():
	
	$eksplozija_mali_kamn.play()
	player_score += 1
	$HUD/Game/score_p1.text = str(player_score)
	$Kamera.tresi()
	ostanek_kamnov -= 1

	
func spawn_kamnov():
	
	$Player.shield_status = 1
	$Player/ShieldTime.start(shield_time)
	
	for n in num_kamen:  # isto kot for n in range (10,100)
		var nov_kamen = kamen.instance()
		nov_kamen.position = get_random_position() # funkcijo smo definirali spodaj
		nov_kamen.connect("kamn_dest", self, "_on_kamn_dest") # signal, connect it to "myself", izvede funkcijo
		add_child(nov_kamen)
		ostanek_kamnov += 1

	
func get_player_rank():
	
	var player_rank: int
	# NI HAJSKOR
	if player_score <= hajskor:
		if player_score > drugi:
			peti = cetrti
			cetrti = tretji
			tretji = drugi
			drugi = player_score
			save_game()	
			player_rank = 2
		elif player_score <= drugi && player_score > tretji:
			peti = cetrti
			cetrti = tretji
			tretji = player_score
			save_game()
			player_rank = 3
		elif player_score <= tretji && player_score > cetrti:
			peti = cetrti
			cetrti = player_score
			save_game()
			player_rank = 4
		elif player_score <= cetrti && player_score > peti:
			peti = player_score
			save_game()
			player_rank = 5
		elif player_score < peti: # ni uvrščen
			player_rank = 0
	# JE HAJSKOR			
	else:
		
		peti = cetrti
		cetrti = tretji
		tretji = drugi
		drugi = hajskor
		hajskor = player_score
		save_game()	
		player_rank = 1
	
	return player_rank	


func get_random_position(): # to funkcijo napišemo, da bo vrnila naključno pozicijo na ekranu
	randomize() # vedno če hočeš randomizirat
	var pozicija = Vector2(rand_range(0, 1280), rand_range(0, 720))
	return pozicija


func _on_Player_raketa_dest(poz_rakete) -> void: # ko zgubiš lajf

	$eksplozija_raketa.play()
	var nova_explozija = explozija_rakete.instance()
	nova_explozija.position = poz_rakete
	nova_explozija.emitting = true
	add_child(nova_explozija)
	
	player_life -= 1
	$HUD/Game/lajf_p1.text = str(player_life) 
	$Kamera.tresi_raketo()
	$Player.hide()
	
	# ugralec je še živ
	if player_life > 0: # ugralec je še živ
		$Player.position = def_pozicija
		$Player.velocity = Vector2.ZERO 
		$novlajf_timer.start(1)
	# igralec je umrl >>> GAME OVER
	else:
		game_over()


func _on_novlajf_timer_timeout() -> void:
	$Player.shield_status = 1
	$Player.show()
	$Player/ShieldTime.start(shield_time)


func _on_deathmode_timeout() -> void:
	cajt -= 1
	$HUD.update_tajm_text(cajt)


func _on_mali_deathmode_timeout() -> void:
	mali_follow = true


# HAJSKOR SISTEM


func save():
	
	var save_dict = {
		"hajskor": hajskor, # key: variabla
		"drugi": drugi,
		"tretji": tretji,
		"cetrti": cetrti,
		"peti": peti	
	}
	return save_dict


func save_game():
	
	var save_game = File.new() # nardi nov filet
	save_game.open("user://savegame.txt", File.WRITE) # sejva na lokacijo
	save_game.store_line(to_json(save()))
	save_game.close()
	
	
func load_game():
	var save_game = File.new() # nardi nov filet
	if not save_game.file_exists("user://savegame.txt"): # preveri, če filet obstaja
		# print("ni fileta")
		return # cancel all and return to start
	save_game.open("user://savegame.txt", File.READ) # preberi filet
	
	# dobi linijo na kateri trenutno smo in jo parsa ...  get save data
	var current_line = parse_json (save_game.get_line())
	
	# tukaj najde hajskor kluč in ga izpiše
	hajskor = current_line["hajskor"]
	drugi = current_line["drugi"]
	tretji = current_line["tretji"]
	cetrti = current_line["cetrti"]
	peti = current_line["peti"]
	
	save_game.close()
