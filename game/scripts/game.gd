extends Node2D

onready var tween = Tween.new()
onready var ship = get_node("ship")
onready var character_story = get_node("UICanvas/CharacterStory")
var cam 
const SHOW_MAP_DURATION = 2
const MAP_ZOOM = 20
const NORMAL_ZOOM = 2

const MODE_MAP = 0
const MODE_NORMAL = 1
var mode = MODE_NORMAL

onready var scripts = {
	1 : "Parece que alguien está dedicando su tiempo en el noble arte del adoctrinamiento y vaciado de cuerpos. Restos de personas, como pellejos, tal vez se parezcan más a mi ahora que cuando vivían."
}

var history = {}

func _ready():
	get_node("Boundary").connect("body_enter",self,"_ship_body_enter")
		
	cam = ship.get_node("Camera2D")
	add_child(tween)
	
	_set_scripts()
	_add_space_crap()
	_handle_ship_messages()
	
	set_process_input(true)

func _set_scripts():
	get_node("SpaceStation1").set_script(scripts)
	
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

func _ship_exit_in_station(body):
	if body.get_name() != 'ship':
		return
	character_story.enable_messages()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if mode == MODE_NORMAL:
			mode = MODE_MAP
			_zoom_interpolation(MAP_ZOOM)
		else:
			mode = MODE_NORMAL
			_zoom_interpolation(NORMAL_ZOOM)

func _ship_body_enter(body):
	if body.get_name() != 'ship':
		return
	get_node("UICanvas/ZoneTitle").fade_in()

func _zoom_interpolation(zoom):
	tween.stop_all()
	tween.interpolate_method(cam,'change_zoom',cam.zoom_scale,zoom,SHOW_MAP_DURATION, tween.TRANS_LINEAR,tween.EASE_IN)
	tween.start()