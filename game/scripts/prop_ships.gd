extends Node2D

var textures = [load("res://assets/graphics/day_tentacle.tex"),
load("res://assets/graphics/supply.tex"),
load("res://assets/graphics/burger_box_1.tex")]

var max_x = 0
var max_y = 0
const COUNT = 200

func generate(x, y):
	randomize()
	for i in range(COUNT):
		max_x = x
		max_y = y
		add_ship()

func add_ship():
	var rigid = RigidBody2D.new()
	var s = Sprite.new()
	var texture = textures[rand_range(0, randi() % textures.size()+1)]
	s.set_texture(texture)
	var pos = Vector2(rand_range(0, max_x), rand_range(0, max_y))
	rigid.set_pos(pos)
	
	rigid.set_script(load("res://scripts/random_prop_ship.gd"))
	rigid.add_child(s)
	add_child(rigid)
	