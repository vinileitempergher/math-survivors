extends Node2D

@onready var arvore = $arvore
@export var quantidade = 800
@export var x_min = -1700
@export var x_max = 1720
@export var y_min = -1720
@export var y_max = 1720
@export var distancia_minima = 100.0

func _ready():
	randomize()
	var posicoes = []

	for i in range(quantidade):
		var pos = gerar_posicao_valida(posicoes, distancia_minima)
		if pos != null:
			var copia = arvore.duplicate()
			copia.position = pos
			add_child(copia)
			posicoes.append(pos)

func gerar_posicao_valida(posicoes: Array, distancia_minima: float):
	var tentativas = 0
	while tentativas < 50:
		var x = randf_range(x_min, x_max)
		var y = randf_range(y_min, y_max)
		var nova_pos = Vector2(x, y)
		var valido = true

		for p in posicoes:
			if p.distance_to(nova_pos) < distancia_minima:
				valido = false
				break

		if valido:
			return nova_pos
		tentativas += 1

	return null
