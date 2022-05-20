extends Camera2D

var t = 0 # čas kako ... dodati morsmo funkcijo  y = sin (x * freq), kjer je 
var freq = 100 # hitros tresenja
var razlika = 0.0 # pokaže velikost tresenja
var x_zamik = 0
var y_zamik = 0
var anim_time = 10


func _process(delta: float) -> void:
	# get it to offset
	t += delta # čas je enako delta, ki arašča z vsakim frejmom
	razlika = lerp(razlika, 0, delta * anim_time) # interpoliramo od tresenja do nule v delts času
	offset_h = sin(t * freq + x_zamik) * razlika
	offset_v = sin(t * freq + y_zamik) * razlika # tole da diagonalno gibanje, zato randomizirasmo štart obeh smeri  smeri

func tresi():
	randomize()
	x_zamik = rand_range(0,2*PI) # 2*PI dodamo da kroži
	y_zamik = rand_range(0,2*PI)
	razlika = 0.2
	
func tresi_raketo():
	randomize()
	x_zamik = rand_range(0, 2*PI) # 2*PI dodamo da kroži
	y_zamik = rand_range(0, 2*PI)
	razlika = 0.6
	anim_time = 7
