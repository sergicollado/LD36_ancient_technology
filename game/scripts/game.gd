extends Node2D

onready var tween = Tween.new()
onready var ship = get_node("ship")
onready var character_story = get_node("UICanvas/CharacterStory")
var current_song = 0

var cam 
const SHOW_MAP_DURATION = 2
const MAP_ZOOM = 8
const NORMAL_ZOOM = 4

const MODE_MAP = 0
const MODE_NORMAL = 1
var mode = MODE_NORMAL

var lm7 = tr("LM7") 
var lm8 = tr("LM8") 
var lm9 = tr("LM9") 
var end = lm7+lm8+lm9
onready var text = {
	"SpaceStation1" : { "LM1" : tr("LM1") },
	"SpaceStation2" : { "LM2" : tr("LM2") },
	"SpaceStation3" : { "LM3" : tr("LM3") },
	"SpaceStation4" : { "LM4" : tr("LM4") },
	"SpaceStation5" : { "LM5" : tr("LM5") },
	"SpaceStation6" : { "LM6" : tr("LM6") },
	"SpaceStation7" : { "LM7" : end}
}

var history = {}

func _ready():
	get_node("Boundary").connect("body_enter",self,"_ship_body_enter")
	get_node("SpaceStation7").connect("landmark_visited",self, "_finish_game")
	cam = ship.get_node("Camera2D")
	add_child(tween)
	
	_set_texts()
	_add_space_crap()
	_handle_ship_messages()
	
	for lm in get_tree().get_nodes_in_group("landmarks"):
		lm.connect("landmark_visited",self, "_ship_exit_in_station_message")
	
	set_process_input(true)

func _landmark_visited(code):
	if(code == "LM1"):
		ship.set_radar(get_node("SpaceStation2").get_pos())
	if(code == "LM2"):
		ship.hide_radar()
	
func _set_texts():
	get_node("SpaceStation1").set_text(text['SpaceStation1'])
	get_node("SpaceStation2").set_text(text['SpaceStation2'])
	get_node("SpaceStation3").set_text(text['SpaceStation3'])
	get_node("SpaceStation4").set_text(text['SpaceStation4'])
	get_node("SpaceStation5").set_text(text['SpaceStation5'])
	get_node("SpaceStation6").set_text(text['SpaceStation6'])
	get_node("SpaceStation7").set_text(text['SpaceStation7'])
	
func _handle_ship_messages():
	for station in get_tree().get_nodes_in_group("stations"):
		station.connect("body_enter",self, "_ship_enter_in_station")
		station.connect("body_exit",self, "_ship_exit_in_station")
	
func _add_space_crap():
	var x = get_node("Boundary/CollisionShape2D").get_pos().x
	var y = get_node("Boundary/CollisionShape2D").get_pos().y
	get_node("Asteroids").generate(x, y)
	get_node("PropShips").generate(x, y)

func _ship_enter_in_station(body):
	if body.get_name() != 'ship':
		return
	character_story.disable_messages()

func _ship_exit_in_station_message(message):
	character_story.enable_messages()
	
func _ship_exit_in_station(body):
	if body.get_name() != 'ship':
		return
	
	if current_song == 0:
		get_node("StreamPlayer01").stop()
		get_node("StreamPlayer02").play()
		current_song = 1
	else:
		get_node("StreamPlayer02").stop()
		get_node("StreamPlayer01").play()
		current_song = 0

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if mode == MODE_NORMAL:
			mode = MODE_MAP
			_zoom_interpolation(MAP_ZOOM)
		else:
			mode = MODE_NORMAL
			_zoom_interpolation(NORMAL_ZOOM)
	if event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())

func _finish_game(message):
	get_node("UICanvas/ZoneTitle").fade_in()

func _zoom_interpolation(zoom):
	tween.stop_all()
	tween.interpolate_method(cam,'change_zoom',cam.zoom_scale,zoom,SHOW_MAP_DURATION, tween.TRANS_LINEAR,tween.EASE_IN)
	tween.start()