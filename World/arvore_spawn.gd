extends Node2D 
@onready var arvore = $arvore 
@export var quantidade = 10000 

@export var x_min = -1800 
@export var x_max = 1800 
@export var y_min = -1800 
@export var y_max = 1800 

func _ready(): 
	randomize() 
	for i in range(quantidade): 
		var copia = arvore.duplicate() 
		var x = randf_range(x_min, x_max) 
		var y = randf_range(y_min, y_max) 
		copia.position = Vector2(x, y) 
		add_child(copia)
