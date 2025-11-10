extends Node2D

@onready var rock = $rock
@export var tamanho = 240        # quantidade de rochas por lado
@export var espacamento = 15   # distância entre as rochas

func _ready():
	# canto superior esquerdo (rocha original)
	var origem = rock.position

	# lado esquerdo (vertical)
	for i in range(1, tamanho):
		var copia = rock.duplicate()
		copia.position = origem + Vector2(0, i * espacamento)
		add_child(copia)

	# lado inferior (horizontal)
	for i in range(1, tamanho):
		var copia = rock.duplicate()
		copia.position = origem + Vector2(i * espacamento, (tamanho - 1) * espacamento)
		add_child(copia)

	# lado direito (vertical pra cima)
	for i in range(1, tamanho):
		var copia = rock.duplicate()
		copia.position = origem + Vector2((tamanho - 1) * espacamento, (tamanho - 1 - i) * espacamento)
		add_child(copia)

	# lado superior (horizontal pra esquerda)
	for i in range(1, tamanho - 1):
		var copia = rock.duplicate()
		copia.position = origem + Vector2((tamanho - 1 - i) * espacamento, 0)
		add_child(copia)
