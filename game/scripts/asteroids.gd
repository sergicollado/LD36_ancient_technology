extends Node2D

var textures = [load("res://assets/graphics/meteorito01.atex"),
load("res://assets/graphics/meteorito02.atex"),
load("res://assets/graphics/meteorito03.atex")]

var max_x = 0
var max_y = 0
const COUNT = 800

func generate(x, y):
	randomize()
	for i in range(COUNT):
		max_x = x
		max_y = y
		add_asteroid()

func add_asteroid():
	var s = Sprite.new()
	var texture = textures[rand_range(0, randi() % textures.size()+1)]
	s.set_texture(texture)
	var pos = Vector2(rand_range(0,max_x), rand_range(0,max_y))
	s.set_script(load("res://scripts/random_asteroid.gd"))
	s.set_pos(pos)
	add_child(s)