extends Node2D

onready var kamen = preload("res://scenes/Kamn.tscn") # preload vzame katerokoli sceno ... dobro da smo organizirali že prej
onready var metk = preload("res://scenes/Metk.tscn")
onready var mali_kamn = preload("res://scenes/Mali_kamn.tscn")
onready var player_p1 = preload("res://scenes/Player.tscn")
onready var explozija_rakete = preload ("res://scenes/particles/explozija_rakete.tscn")
onready var eksplozija_metka = preload("res://scenes/particles/explozija_metka.tscn")

export var num_kamen = 1 # začetno število kamnov
export var ekstra_num_kamen = 1 # vsako naslednje število kamnov
var ostanek_kamnov = 0
var serija = 1
var def_pozicija = Vector2(640, 360)
var mali_follow : bool = false

var cajt = 10 # čas do deathmodeta
var cajt_vecanje = 10 # vsak spawn se poveča za ...

# player 1
var score_p1 = 0
var lajf_p1 = 3

var hajskor = 0

var sejvan_hajskor : int

var drugi = 0
var tretji = 0
var cetrti = 0
var peti = 0


####################################################################################################
####################################################################################################


func _ready() -> void:
	
	load_game()
	hajskor = hajskor
	drugi = drugi
	tretji = tretji
	cetrti = cetrti
	peti = peti
	$HUD/rekord.text = "Rekord: " + str(hajskor)
	
	$redzone.hide()
	$deathmode.start()	
	$HUD/tajm.text = str(cajt)
	
	$muzika.play()
	$muzika.set_stream_paused(true) 
	$HUD/lajf_p1.text = "Lajf: " + str(lajf_p1)
	$HUD/serija_kamnov.text = "Serija: " + str(serija)
	
	# zbrišeš vse elemente v grupi kamni
	var gejmover_hud = get_tree().get_nodes_in_group("VisibleInGameOver") 
	for gejmover_hud_element in gejmover_hud:
		gejmover_hud_element.hide()
	
	# prvi SPAWN
	spawn_kamnov() 
	$Player.position = def_pozicija
	$Player.rotation = 0
	$Player.shield_status = 1
	$Player.show()
	$Player/ShieldTime.start(3)

func _process(delta: float) -> void:
	
	if $Player.is_visible ():
		if Input.is_action_just_pressed("shoot"):
			var nov_metk = metk.instance()
			nov_metk.position = $Player.position
			nov_metk.rotation = $Player.rotation
			nov_metk.connect("metek_zadetek", self, "_on_metek_zadetek")
			add_child(nov_metk)
			$laser.play()
	
	# JA	
	if $HUD/igraj_btn.is_visible ():
		if Input.is_action_just_released("ui_accept"):
			get_tree().reload_current_scene()
	elif $HUD/muzika_ja.is_visible():
		if Input.is_action_just_released("ui_accept"):		
			if $muzika.get_stream_paused() == true:
				$muzika.set_stream_paused(false)
			else:
				$muzika.set_stream_paused(true)
	
	# ESC
	if Input.is_action_just_released("ui_cancel"):
		get_tree().change_scene("res://scenes/Hajskor.tscn")
		

	# NOV LEVEL ... to je tukaj ker na koncu ostanejo kamenčki
	if ostanek_kamnov == 0: 
		num_kamen += ekstra_num_kamen # št. dodatnih kamnov
		cajt += cajt_vecanje * serija
		$HUD.update_tajm(cajt)
		spawn_kamnov()	
		$deathmode.start()
		$redzone.hide()
		serija += 1
		$HUD/serija_kamnov.text = "Serija:" + str(serija)
		
	if cajt <= 5:
		$HUD/tajm.modulate = Color.red
	else:
		$HUD/tajm.modulate = Color.white
	
	if cajt == 0: # FOLLOW MODE
		$deathmode.stop()
		$HUD/tajm.text = "DEATH MODE"
		$redzone.show()
		
		# kamni follow
		var vsi_kamni = get_tree().get_nodes_in_group("veliki_kamni") 
		for novi_vsi_kamni in vsi_kamni:
			novi_vsi_kamni.modulate = Color.red
			novi_vsi_kamni.velocity = novi_vsi_kamni.global_position.direction_to($Player.global_position)
			novi_vsi_kamni.global_position += novi_vsi_kamni.velocity * delta * 50
		
		var vsi_mali_kamni = get_tree().get_nodes_in_group("mali_kamni") 
		for novi_vsi_mali_kamni in vsi_mali_kamni:
			novi_vsi_mali_kamni.modulate = Color.red
			
			if mali_follow == true: 
				novi_vsi_mali_kamni.velocity = novi_vsi_mali_kamni.global_position.direction_to($Player.global_position)
				novi_vsi_mali_kamni.global_position += novi_vsi_mali_kamni.velocity * delta * 70


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
		print("ni fileta")
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

# ---		
			
func _on_metek_zadetek(pozicija, rotacija):
	
	$metek_zadetek.play()
	
	var nova_eksplozija_metka = eksplozija_metka.instance()
	nova_eksplozija_metka.position = pozicija
	nova_eksplozija_metka.rotation = rotacija - 3.75
	nova_eksplozija_metka.set_emitting(true)
	add_child(nova_eksplozija_metka)
	
	if score_p1 > hajskor:
		$HUD/score_p1.modulate = Color.yellow
		$HUD/rekord.modulate = Color("727272")

func _on_kamn_dest(poz): # vzame spemenljivko POZ in ji da argument, ki je poslan
	
	$eksplozija_mali_kamn.play()
	
	score_p1 += 1
	$HUD/score_p1.text = "Score: " + str(score_p1)	
	$Kamera.tresi()
	ostanek_kamnov -= 1
	
	$mali_deathmode.start()
	
	for _i in range(3):
		var nov_mali_kamn = mali_kamn.instance()
		nov_mali_kamn.position = poz
		add_child(nov_mali_kamn)
		nov_mali_kamn.connect("mali_kamn_dest", self, "_on_mali_kamn_dest")
		ostanek_kamnov += 1 
		
		
func _on_mali_kamn_dest():
	$eksplozija_mali_kamn.play()
	score_p1 += 1
	$HUD/score_p1.text = "Score: " + str(score_p1)
	$Kamera.tresi()
	ostanek_kamnov -= 1

	
func spawn_kamnov ():
	$Player.shield_status = 1
	$Player/ShieldTime.start(3)
	
	for n in num_kamen:  # isto kot for n in range (10,100)
		var nov_kamen = kamen.instance()
		nov_kamen.position = get_random_position() # funkcijo smo definirali spodaj
		nov_kamen.connect("kamn_dest", self, "_on_kamn_dest") # signal, connect it to "myself", izvede funkcijo
		nov_kamen.connect("mali_kamn_follow", self, "_on_kamn_dest")
		add_child(nov_kamen)
		ostanek_kamnov += 1

func _on_Player_raketa_dest(poz_rakete) -> void: # ko zgubiš lajf

	$eksplozija_raketa.play()
	var nova_explozija = explozija_rakete.instance()
	nova_explozija.position = poz_rakete
	nova_explozija.emitting = true
	add_child(nova_explozija)
	lajf_p1 -= 1
	$HUD/lajf_p1.text = "Lajf: " + str(lajf_p1) 
	$Kamera.tresi_raketo()
	$Player.hide()
	
	# ugralec je še živ
	if lajf_p1 > 0: # ugralec je še živ
		$Player.position = def_pozicija
		$Player.velocity = Vector2.ZERO 
		$novlajf_timer.start(1)
	 
	# igralec je umrl >>> GAME OVER
	else:
		print("on game over")
		print(hajskor)
		print(peti)
		$muzika.stop()
		$HUD/lajf_p1.text = "GAME OVER"
		$HUD/gemovertajmer.start(1) 
		
		# NI HAJSKOR
		if score_p1 <= hajskor:
			$HUD/rezultat.text = "Rezultat: " + String(score_p1)
			$hahaha.play()	
			if score_p1 > drugi:
				peti = cetrti
				cetrti = tretji
				tretji = drugi
				drugi = score_p1
				save_game()		
				$HUD/rezultat.text = "2. mesto: " + String(score_p1)
				print("drugi")
				print(hajskor)
			elif score_p1 <= drugi && score_p1 > tretji:
				peti = cetrti
				cetrti = tretji
				tretji = score_p1
				save_game()
				$HUD/rezultat.text = "3. mesto: " + String(score_p1)
				print("tretji")
				print(hajskor)
			elif score_p1 <= tretji && score_p1 > cetrti:
				peti = cetrti
				cetrti = score_p1
				save_game()
				$HUD/rezultat.text = "4. mesto: " + String(score_p1)
				print("cetrti")
				print(hajskor)
			elif score_p1 <= cetrti && score_p1 > peti:
				peti = score_p1
				save_game()
				$HUD/rezultat.text = "5. mesto: " + String(score_p1)
				print("peti")
				print(hajskor)
			
		# JE HAJSKOR			
		else:
			print("on hasjkor")
			print(hajskor)
			peti = cetrti
			cetrti = tretji
			tretji = drugi
			drugi = hajskor
			hajskor = score_p1
			save_game()		
			$HUD/rezultat.text = "NOV REKORD: " + String(score_p1)
			$HUD/rezultat.modulate = Color.yellow
			$zdravljica.play()
			

func _on_novlajf_timer_timeout() -> void:
	$Player.shield_status = 1
	$Player.show()
	$Player/ShieldTime.start(3)

func _on_gemovertajmer_timeout() -> void:
	$HUD.show_game_over()

func _on_deathmode_timeout() -> void:
	cajt -= 1
	$HUD.update_tajm(cajt)

func _on_mali_deathmode_timeout() -> void:
	mali_follow = true

func get_random_position(): # to funkcijo napišemo, da bo vrnila naključno pozicijo na ekranu
	randomize() # vedno če hočeš randomizirat
	var pozicija = Vector2(rand_range(0, 1280), rand_range(0, 720))
	return pozicija

func _on_muzika_ja_pressed() -> void:

#	if $muzika.get_stream_paused() == true:
#		$muzika.set_stream_paused(false)
#		print("ja+")
#	else:
#		$muzika.set_stream_paused(true)
#		print("ne")
#
		
#	if $muzika.is_playing() == false:
#		$muzika.play()
#	elif $muzika.is_playing() == true && $muzika.set_stream_paused == true:
#		$muzika.set_stream_paused(false) 

#	if $muzika.is_playing() == true && $muzika.volume_db != 0:
#		$muzika.volume_db = 0
#	elif $muzika.is_playing() == true && $muzika.volume_db == 0:
#		$muzika.volume_db = -80
#	elif $muzika.is_playing() == false:
#		$muzika.volume_db = 0
#		$muzika.play()
	pass
