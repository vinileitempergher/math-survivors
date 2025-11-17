extends CharacterBody2D


var base_movement_speed = 800.0
var movement_speed = 200.0
var hp = 80
var maxhp = 80
var last_movement = Vector2.UP
var time = 0

var map_bounds = {
	"left": 0.0,
	"right": 0.0,
	"top": 0.0,
	"bottom": 0.0
}

var enemy_kills = 0
var damage_flash_time = 0.0
var is_paused = false

var experience = 0
var experience_level = 1
var collected_experience = 0

#Attacks
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javelin.tscn")

#AttackNodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
@onready var tornadoTimer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer = get_node("%TornadoAttackTimer")
@onready var javelinBase = get_node("%JavelinBase")

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 0
var icespear_attackspeed = 1.5
var icespear_level = 0

#Tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attackspeed = 3
var tornado_level = 0

#Javelin
var javelin_ammo = 0
var javelin_level = 0


#Enemy Related
var enemy_close = []


@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")
@onready var camera = $Camera2D

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var sndLevelUp = get_node("%snd_levelup")
@onready var healthBar = get_node("%HealthBar")
@onready var lblTimer = get_node("%lblTimer")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")

@onready var deathPanel = get_node("%DeathPanel")
@onready var lblResult = get_node("%lbl_Result")
@onready var sndVictory = get_node("%snd_victory")
@onready var sndLose = get_node("%snd_lose")
@onready var lblKills = get_node("%lblKills")

var minimap_panel = null

#Signal
signal playerdeath

#QUIZ SYSTEM
var quiz_questions = {
	"easy": [
	# Porcentagem
	{"question": "Porcentagem: 25% de 200 = ?", "answer": 50, "options": [40, 50, 60, 75]},
	{"question": "Porcentagem: 10% de 150 = ?", "answer": 15, "options": [10, 12, 15, 20]},
	{"question": "Porcentagem: 50% de 90 = ?", "answer": 45, "options": [40, 45, 50, 55]},
	{"question": "Porcentagem: 1% de 500 = ?", "answer": 5, "options": [0.5, 5, 50, 100]},
	# Notação científica (resultados inteiros)
	{"question": "Notação científica: 3 × 10^2 = ?", "answer": 300, "options": [30, 300, 3000, 200]},
	{"question": "Notação científica: 7 × 10^1 = ?", "answer": 70, "options": [7, 17, 70, 700]},
	{"question": "Notação científica: 1 × 10^3 = ?", "answer": 1000, "options": [10, 100, 1000, 10000]},
	{"question": "Notação científica: 2,5 × 10^2 = ?", "answer": 250, "options": [25, 250, 2500, 0.25]},
	# Potenciação
	{"question": "Potenciação: 2^3 = ?", "answer": 8, "options": [6, 8, 9, 12]},
	{"question": "Potenciação: 5^2 = ?", "answer": 25, "options": [20, 24, 25, 30]},
	{"question": "Potenciação: 10^3 = ?", "answer": 1000, "options": [30, 100, 1000, 10000]},
	{"question": "Potenciação: 7^0 = ?", "answer": 1, "options": [0, 1, 7, 10]},
	{"question": "Potenciação: (-2)^2 = ?", "answer": 4, "options": [-4, 2, 4, -2]},
	# Raiz
	{"question": "Raiz quadrada: √81 = ?", "answer": 9, "options": [7, 8, 9, 10]},
	{"question": "Raiz quadrada: √49 = ?", "answer": 7, "options": [5, 6, 7, 8]},
	{"question": "Raiz quadrada: √100 = ?", "answer": 10, "options": [1, 10, 20, 100]},
	{"question": "Raiz quadrada: √1 = ?", "answer": 1, "options": [0, 0.5, 1, 10]},
	# Área e perímetro
	{"question": "Área: retângulo 5 × 3 = ?", "answer": 15, "options": [12, 15, 18, 20]},
	{"question": "Perímetro: quadrado de lado 6 = ?", "answer": 24, "options": [20, 22, 24, 26]},
	{"question": "Área: quadrado de lado 4 = ?", "answer": 16, "options": [8, 12, 16, 20]},
	{"question": "Perímetro: retângulo 5 × 3 = ?", "answer": 16, "options": [15, 16, 18, 20]},
	# Números inteiros
	{"question": "Inteiros: (-7) + 12 = ?", "answer": 5, "options": [3, 4, 5, 6]},
	{"question": "Inteiros: 10 - 15 = ?", "answer": -5, "options": [5, -5, -10, -15]},
	{"question": "Inteiros: (-3) × 4 = ?", "answer": -12, "options": [12, -1, -7, -12]},
	{"question": "Inteiros: (-10) ÷ (-2) = ?", "answer": 5, "options": [5, -5, 8, -8]},
	# Expressões Algébricas (Valor Numérico)
	{"question": "Álgebra: Se x = 2, qual o valor de x + 5?", "answer": 7, "options": [5, 6, 7, 8]},
	{"question": "Álgebra: Se y = 3, qual o valor de 2y?", "answer": 6, "options": [3, 5, 6, 9]},
	{"question": "Álgebra: Se a = 1, qual o valor de a - 10?", "answer": -9, "options": [9, -9, 10, -11]},
	# Equações de 1º Grau (Simples)
	{"question": "Equação: x + 2 = 5, x = ?", "answer": 3, "options": [1, 2, 3, 4]},
	{"question": "Equação: y - 1 = 7, y = ?", "answer": 8, "options": [5, 6, 7, 8]}
	],
	"medium": [
	# Porcentagem
	{"question": "Porcentagem: 30% de 250 = ?", "answer": 75, "options": [70, 72, 75, 80]},
	{"question": "Porcentagem: 15% de 240 = ?", "answer": 36, "options": [30, 32, 36, 40]},
	{"question": "Porcentagem: 120 é 20% de qual número?", "answer": 600, "options": [24, 240, 600, 1200]},
	{"question": "Porcentagem: Um produto de R$80 teve 10% de desconto. Qual o novo preço?", "answer": 72, "options": [8, 70, 72, 79]},
	# Notação científica (expoente inteiro e valores inteiros)
	{"question": "Notação científica: Em 5 × 10^n = 5000, n = ?", "answer": 3, "options": [2, 3, 4, 5]},
	{"question": "Notação científica: 6 × 10^3 = ?", "answer": 6000, "options": [600, 6000, 60000, 600000]},
	{"question": "Notação científica: Escreva 45000 em notação científica.", "answer": "4,5 × 10^4", "options": ["45 × 10^3", "4,5 × 10^4", "4,5 × 10^3", "0,45 × 10^5"]},
	{"question": "Notação científica: (2 × 10^2) × (3 × 10^1) = ?", "answer": 6000, "options": [60, 600, 6000, 60000]},
	# Potenciação
	{"question": "Potenciação: 3^4 = ?", "answer": 81, "options": [27, 64, 81, 96]},
	{"question": "Potenciação: 10^5 ÷ 10^3 = ?", "answer": 100, "options": [10, 100, 1000, 10000]},
	{"question": "Potenciação: (-3)^3 = ?", "answer": -27, "options": [27, -27, 9, -9]},
	{"question": "Potenciação: 5^(-1) = ?", "answer": 0.2, "options": [-5, 5, 0.5, 0.2]},
	{"question": "Potenciação: (2^2)^3 = ?", "answer": 64, "options": [12, 16, 32, 64]},
	# Raiz
	{"question": "Raiz quadrada: √225 = ?", "answer": 15, "options": [13, 14, 15, 16]},
	{"question": "Raiz cúbica: ³√8 = ?", "answer": 2, "options": [1, 2, 3, 4]},
	{"question": "Raiz cúbica: ³√27 = ?", "answer": 3, "options": [3, 6, 9, 1.8]},
	# Área e perímetro
	{"question": "Área: triângulo de base 12 e altura 8 = ?", "answer": 48, "options": [36, 48, 60, 96]},
	{"question": "Perímetro: retângulo 9 × 7 = ?", "answer": 32, "options": [28, 30, 32, 34]},
	{"question": "Área: círculo de raio 5 (use π ≈ 3) = ?", "answer": 75, "options": [15, 30, 75, 150]},
	{"question": "Perímetro: circunferência de raio 10 (use π ≈ 3,14) = ?", "answer": 62.8, "options": [31.4, 62.8, 100, 314]},
	# Números inteiros
	{"question": "Inteiros: (-12) - (-7) = ?", "answer": -5, "options": [-19, -5, 5, 7]},
	{"question": "Inteiros: (-5) × (-3) + 4 = ?", "answer": 19, "options": [11, 19, -11, -19]},
	# Expressões Algébricas (Valor Numérico)
	{"question": "Álgebra: Se x = 2 e y = 3, qual o valor de 3x + y?", "answer": 9, "options": [8, 9, 10, 11]},
	{"question": "Álgebra: Se a = 5 e b = -1, qual o valor de a × b?", "answer": -5, "options": [5, -5, 4, -4]},
	# Equações de 1º Grau
	{"question": "Equação: 2x + 1 = 11, x = ?", "answer": 5, "options": [4, 5, 6, 10]},
	{"question": "Equação: 3y - 5 = 10, y = ?", "answer": 5, "options": [3, 4, 5, 6]},
	# Estatística (Média)
	{"question": "Estatística: Qual a média de 5, 10 e 15?", "answer": 10, "options": [5, 10, 15, 30]},
	{"question": "Estatística: Qual a mediana de 1, 2, 5, 7, 10?", "answer": 5, "options": [1, 2, 5, 7]},
	{"question": "Estatística: Qual a moda de 2, 3, 3, 5, 7?", "answer": 3, "options": [2, 3, 5, 7]}
	],
	"hard": [
	# Porcentagem
	{"question": "Porcentagem: Aumentar 200 em 15% resulta em?", "answer": 230, "options": [215, 220, 230, 240]},
	{"question": "Porcentagem: Desconto de 25% em 360 resulta em?", "answer": 270, "options": [240, 260, 270, 300]},
	{"question": "Porcentagem: Um produto foi de R$150 para R$180. Qual foi o aumento percentual?", "answer": "20%", "options": ["15%", "20%", "25%", "30%"]},
	{"question": "Porcentagem: Paguei R$120 por um item com 20% de desconto. Qual era o preço original?", "answer": 150, "options": [140, 144, 150, 160]},
	# Notação científica
	{"question": "Notação científica: Em 3 × 10^n = 30000, n = ?", "answer": 4, "options": [3, 4, 5, 6]},
	{"question": "Notação científica: 4 × 10^4 + 3 × 10^4 = ?", "answer": 70000, "options": [40000, 7000, 70000, 700000]},
	{"question": "Notação científica: (8 × 10^5) ÷ (2 × 10^2) = ?", "answer": "4 × 10^3", "options": ["4 × 10^2", "4 × 10^3", "4 × 10^4", "4 × 10^7"]},
	{"question": "Notação científica: 0,00052 em notação científica = ?", "answer": "5,2 × 10^-4", "options": ["5,2 × 10^4", "5,2 × 10^-3", "5,2 × 10^-4", "52 × 10^-5"]},
	# Potenciação
	{"question": "Potenciação: 2^5 × 2^3 = ?", "answer": 256, "options": [128, 200, 256, 512]},
	{"question": "Potenciação: (-4)^3 = ?", "answer": -64, "options": [-128, -64, 64, 256]},
	{"question": "Potenciação: 10^3 ÷ 10^5 = ?", "answer": 0.01, "options": [100, 0.01, -100, 0.1]},
	{"question": "Potenciação: (2/3)^(-2) = ?", "answer": 2.25, "options": ["4/9", "9/4", "6/4", "4/6"]},
	# Raiz
	{"question": "Raiz: √144 + √81 = ?", "answer": 21, "options": [20, 21, 22, 24]},
	{"question": "Raiz: √(7² + 24²) = ?", "answer": 25, "options": [31, 25, 49, 576]},
	# Área e perímetro
	{"question": "Área: paralelogramo base 14 e altura 9 = ?", "answer": 126, "options": [96, 112, 126, 140]},
	{"question": "Perímetro: retângulo 13 × 9 = ?", "answer": 44, "options": [40, 42, 44, 46]},
	{"question": "Área: trapézio (B=10, b=6, h=5) = ?", "answer": 40, "options": [35, 40, 45, 50]},
	{"question": "Área: losango (D=8, d=6) = ?", "answer": 24, "options": [14, 24, 28, 48]},
	# Números inteiros
	{"question": "Inteiros: |−18| − |−7| = ?", "answer": 11, "options": [9, 10, 11, 12]},
	{"question": "Inteiros: (-2)^3 + 5 × 4 = ?", "answer": 12, "options": [-8, 12, 28, -28]},
	# Expressões Algébricas (Produtos Notáveis)
	{"question": "Álgebra: (x + 3)² = ?", "answer": "x² + 6x + 9", "options": ["x² + 9", "x² + 3x + 9", "x² + 6x + 9", "x + 6"]},
	{"question": "Álgebra: (y - 5)(y + 5) = ?", "answer": "y² - 25", "options": ["y² + 25", "y² - 10y + 25", "y² - 25", "y² - 10"]},
	# Equações de 1º Grau
	{"question": "Equação: 5(x - 1) = 2x + 4, x = ?", "answer": 3, "options": [1, 2, 3, 4]},
	{"question": "Equação: x/2 + 3 = 7, x = ?", "answer": 8, "options": [4, 6, 8, 10]},
	# Sistemas de Equações
	{"question": "Sistema: Se x+y=10 e x-y=4, qual o valor de x?", "answer": 7, "options": [5, 6, 7, 8]},
	{"question": "Sistema: Se x+y=10 e x-y=4, qual o valor de y?", "answer": 3, "options": [2, 3, 4, 5]},
	# Estatística (Média, Moda, Mediana)
	{"question": "Estatística: Média das notas 8, 9, 7, 6 = ?", "answer": 7.5, "options": [7, 7.5, 8, 8.5]},
	{"question": "Estatística: Mediana de 8, 10, 4, 12 = ?", "answer": 9, "options": [8, 9, 10, 11]},
	# Geometria (Polígonos)
	{"question": "Geometria: Soma dos ângulos internos de um pentágono = ?", "answer": 540, "options": [180, 360, 540, 720]},
	{"question": "Geometria: Quantas diagonais tem um hexágono?", "answer": 9, "options": [6, 8, 9, 12]}
	]
}

var current_quiz_question = {}
var quiz_difficulty = ""
var quiz_panel_visible = false

func _ready():
	var viewport_size = get_viewport().get_visible_rect().size
	var half_viewport = viewport_size / 2
	
	var rock_origin = Vector2(-1718, -1833)
	var rock_size = 240
	var rock_spacing = 15
	
	var map_left = rock_origin.x
	var map_right = rock_origin.x + (rock_size - 1) * rock_spacing
	var map_top = rock_origin.y
	var map_bottom = rock_origin.y + (rock_size - 1) * rock_spacing
	
	camera.limit_left = int(map_left + half_viewport.x)
	camera.limit_right = int(map_right - half_viewport.x)
	camera.limit_top = int(map_top + half_viewport.y)
	camera.limit_bottom = int(map_bottom - half_viewport.y)
	camera.limit_smoothed = true
	
	map_bounds.left = camera.limit_left
	map_bounds.right = camera.limit_right
	map_bounds.top = camera.limit_top
	map_bounds.bottom = camera.limit_bottom
	
	upgrade_character("icespear1")
	attack()
	set_expbar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0,0,0)
	update_kills_display()
	setup_minimap()
	

func _physics_process(delta):
	if Input.is_action_just_pressed("pause") and !quiz_panel_visible and hp > 0:
		toggle_pause()
	
	if damage_flash_time > 0:
		damage_flash_time -= delta
		sprite.modulate = Color(1, 1 - damage_flash_time, 1 - damage_flash_time)
	else:
		sprite.modulate = Color.WHITE
	movement()
	update_minimap()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	var pause_panel = get_node_or_null("GUILayer/GUI/PausePanel")
	if is_paused:
		show_pause_menu()
	elif pause_panel:
		pause_panel.queue_free()

func show_pause_menu():
	var pause_panel = Panel.new()
	pause_panel.name = "PausePanel"
	pause_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_panel.set_anchor(SIDE_LEFT, 0.3)
	pause_panel.set_anchor(SIDE_RIGHT, 0.7)
	pause_panel.set_anchor(SIDE_TOP, 0.3)
	pause_panel.set_anchor(SIDE_BOTTOM, 0.7)
	
	var gui_layer = get_node("GUILayer/GUI")
	gui_layer.add_child(pause_panel)
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 8)
	pause_panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "PAUSA"
	title.add_theme_font_override("font", preload("res://Font/tenderness.otf"))
	title.add_theme_font_size_override("font_size", 32)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# Reduz a altura ocupada pelo título para que os botões fiquem mais próximos (subam)
	# Em vez de expandir verticalmente, damos uma altura mínima e permitimos encolher
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	title.custom_minimum_size = Vector2(0, 30)
	title.size_flags_stretch_ratio = 0.2
	vbox.add_child(title)
	
	var resume_btn = Button.new()
	resume_btn.text = "Continuar"
	resume_btn.add_theme_font_override("font", preload("res://Font/tenderness.otf"))
	# Make the button use the full available width and reduce size/spacing so it fits nicely
	resume_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# Diminuir o tamanho dos botões: altura menor e não expandir verticalmente
	resume_btn.custom_minimum_size = Vector2(0, 40)
	resume_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	# Não forçar stretch vertical
	resume_btn.size_flags_stretch_ratio = 0.0
	resume_btn.add_theme_font_size_override("font_size", 18)
	resume_btn.pressed.connect(toggle_pause)
	vbox.add_child(resume_btn)
	
	var menu_btn = Button.new()
	menu_btn.text = "Menu Principal"
	menu_btn.add_theme_font_override("font", preload("res://Font/tenderness.otf"))
	# Same adjustments for the menu button so the label fits inside the panel
	menu_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# Diminuir o tamanho dos botões: altura menor e não expandir verticalmente
	menu_btn.custom_minimum_size = Vector2(0, 40)
	menu_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	# Não forçar stretch vertical
	menu_btn.size_flags_stretch_ratio = 0.0
	menu_btn.add_theme_font_size_override("font_size", 18)
	menu_btn.pressed.connect(_on_btn_menu_click_end)
	vbox.add_child(menu_btn)

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false

	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()
	
	var new_pos = global_position
	new_pos.x = clamp(new_pos.x, map_bounds.left, map_bounds.right)
	new_pos.y = clamp(new_pos.y, map_bounds.top, map_bounds.bottom)
	global_position = new_pos

func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attackspeed * (1-spell_cooldown)
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed * (1-spell_cooldown)
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	if javelin_level > 0:
		spawn_javelin()

func _on_hurt_box_hurt(damage, _angle, _knockback):
	hp -= clamp(damage-armor, 1.0, 999.0)
	healthBar.max_value = maxhp
	healthBar.value = hp
	damage_flash_time = 0.2
	camera_shake()
	if hp <= 0:
		death()

func camera_shake():
	var shake_amount = 5.0
	var shake_duration = 0.2
	var tween = create_tween()
	tween.tween_property(camera, "offset", Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount)), 0.05)
	tween.tween_property(camera, "offset", Vector2(randf_range(-shake_amount/2, shake_amount/2), randf_range(-shake_amount/2, shake_amount/2)), 0.05)
	tween.tween_property(camera, "offset", Vector2.ZERO, shake_duration - 0.1)

func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo + additional_attacks
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout():
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo + additional_attacks
	tornadoAttackTimer.start()

func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornadoAttackTimer.start()
		else:
			tornadoAttackTimer.stop()

func spawn_javelin():
	var get_javelin_total = javelinBase.get_child_count()
	var calc_spawns = (javelin_ammo + additional_attacks) - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelinBase.add_child(javelin_spawn)
		calc_spawns -= 1
	#Upgrade Javelin
	var get_javelins = javelinBase.get_children()
	for i in get_javelins:
		if i.has_method("update_javelin"):
			i.update_javelin()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)

func calculate_experience(gem_exp):
	var exp_required = calculate_experiencecap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experiencecap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
	
	set_expbar(experience, exp_required)

func calculate_experiencecap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = exp_cap + 95 * (experience_level - 19) * 8
	else:
		exp_cap = 255 + (experience_level-39)*12
		
	return exp_cap
		
func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelup():
	sndLevelUp.play()
	lblLevel.text = str("Level: ",experience_level)
	show_quiz_difficulty_selection()

func upgrade_character(upgrade):
	match upgrade:
		"icespear1":
			icespear_level = 1
			icespear_baseammo += 1
		"icespear2":
			icespear_level = 2
			icespear_baseammo += 1
		"icespear3":
			icespear_level = 3
		"icespear4":
			icespear_level = 4
			icespear_baseammo += 2
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"javelin1":
			javelin_level = 1
			javelin_ammo = 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			speed += 0.05
			movement_speed = base_movement_speed * (1 + speed)
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
			maxhp += 5
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)
	
func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrade_options: #If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #Check for PreRequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null

func change_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0,get_m)
	if get_s < 10:
		get_s = str(0,get_s)
	lblTimer.text = str(get_m,":",get_s)

func on_enemy_killed():
	enemy_kills += 1
	update_kills_display()

func update_kills_display():
	lblKills.text = str("Kills: ", enemy_kills)

func setup_minimap():
	var gui = get_node("GUILayer/GUI")
	minimap_panel = Control.new()
	minimap_panel.name = "Minimap"
	minimap_panel.position = Vector2(545, 265)
	minimap_panel.size = Vector2(80, 80)
	minimap_panel.draw.connect(_draw_minimap)
	gui.add_child(minimap_panel)

func update_minimap():
	if minimap_panel and is_instance_valid(minimap_panel):
		minimap_panel.queue_redraw()

func _draw_minimap():
	if not minimap_panel:
		return
	
	var minimap_size = Vector2(80, 80)
	var map_width = map_bounds.right - map_bounds.left
	var map_height = map_bounds.bottom - map_bounds.top
	
	if map_width == 0 or map_height == 0:
		return
	
	var scale_x = minimap_size.x / map_width
	var scale_y = minimap_size.y / map_height
	
	var player_pos_normalized = Vector2(
		(global_position.x - map_bounds.left) * scale_x,
		(global_position.y - map_bounds.top) * scale_y
	)
	
	var shadow_offset = Vector2(2, 2)
	minimap_panel.draw_rect(Rect2(shadow_offset, minimap_size), Color(0, 0, 0, 0.5), true)
	
	minimap_panel.draw_rect(Rect2(Vector2.ZERO, minimap_size), Color(0.1, 0.1, 0.15, 0.85), true)
	
	var corner_radius = 4.0
	for i in range(4):
		var angle = i * PI / 2
		var corner_pos = Vector2.ZERO
		if i == 0:
			corner_pos = Vector2(corner_radius, corner_radius)
		elif i == 1:
			corner_pos = Vector2(minimap_size.x - corner_radius, corner_radius)
		elif i == 2:
			corner_pos = Vector2(minimap_size.x - corner_radius, minimap_size.y - corner_radius)
		else:
			corner_pos = Vector2(corner_radius, minimap_size.y - corner_radius)
	
	minimap_panel.draw_rect(Rect2(Vector2.ZERO, minimap_size), Color(0.3, 0.6, 0.8, 0.4), false, 2)
	minimap_panel.draw_rect(Rect2(Vector2(1, 1), minimap_size - Vector2(2, 2)), Color(0.4, 0.7, 1.0, 0.2), false, 1)
	
	for enemy in enemy_close:
		if is_instance_valid(enemy):
			var enemy_pos_normalized = Vector2(
				(enemy.global_position.x - map_bounds.left) * scale_x,
				(enemy.global_position.y - map_bounds.top) * scale_y
			)
			if enemy_pos_normalized.x >= 0 and enemy_pos_normalized.x <= minimap_size.x and \
			   enemy_pos_normalized.y >= 0 and enemy_pos_normalized.y <= minimap_size.y:
				minimap_panel.draw_circle(enemy_pos_normalized, 2, Color(1, 0.2, 0.2, 0.9))
				minimap_panel.draw_circle(enemy_pos_normalized, 3, Color(1, 0.4, 0.4, 0.3), false, 1)
	
	minimap_panel.draw_circle(player_pos_normalized, 3.5, Color(0, 0, 0, 0.4))
	minimap_panel.draw_circle(player_pos_normalized, 3, Color(0.2, 1, 0.3, 1))
	minimap_panel.draw_circle(player_pos_normalized, 4, Color(0.5, 1, 0.6, 0.6), false, 1.5)
	minimap_panel.draw_circle(player_pos_normalized, 1.2, Color(1, 1, 1, 0.8))

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)

func death():
	deathPanel.visible = true
	emit_signal("playerdeath")
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel,"position",Vector2(220,50),3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	var stats_text = "\n\nKills: %d\nTempo: %d:%02d\nLevel: %d" % [enemy_kills, int(time/60), time % 60, experience_level]
	
	if time >= 300:
		lblResult.text = "You Win!" + stats_text
		sndVictory.play()
	else:
		lblResult.text = "You Lose" + stats_text
		sndLose.play()

func show_quiz_difficulty_selection():
	var difficulty_panel = Panel.new()
	difficulty_panel.name = "DifficultyPanel"
	difficulty_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	difficulty_panel.visible = true
	
	# ÂNCORAS MAIORES para ter mais espaço vertical
	difficulty_panel.set_anchor(SIDE_LEFT, 0.35)    
	difficulty_panel.set_anchor(SIDE_RIGHT, 0.65)   
	difficulty_panel.set_anchor(SIDE_TOP, 0.15)     # Mais espaço em cima
	difficulty_panel.set_anchor(SIDE_BOTTOM, 0.85)  # Mais espaço embaixo
	
	var gui_layer = get_node("GUILayer/GUI")
	gui_layer.add_child(difficulty_panel)
	
	# Título com menos altura
	var title = Label.new()
	title.text = "Escolha a Dificuldade"
	title.layout_mode = Control.PRESET_FULL_RECT
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_bottom = 40.0  # Menor altura
	title.add_theme_font_override("font", preload("res://Font/tenderness.otf"))
	title.add_theme_font_size_override("font_size", 16)  # Fonte menor
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	difficulty_panel.add_child(title)
	
	# Container com mais espaço
	var options_container = VBoxContainer.new()
	options_container.name = "DifficultyOptions"
	options_container.layout_mode = Control.PRESET_FULL_RECT
	options_container.offset_left = 15.0
	options_container.offset_top = 45.0   # Começa após o título
	options_container.offset_right = -15.0
	options_container.offset_bottom = -15.0
	options_container.add_theme_constant_override("separation", 8)  # Menos espaçamento
	difficulty_panel.add_child(options_container)
	
	# Botões menores
	var easy_btn = Button.new()
	easy_btn.text = "🟢 Fácil"
	easy_btn.custom_minimum_size = Vector2(0, 35)  # Altura menor
	easy_btn.add_theme_font_override("font", preload("res://Font/tenderness.otf"))
	easy_btn.add_theme_font_size_override("font_size", 14)
	easy_btn.pressed.connect(_on_difficulty_selected.bind("easy"))
	options_container.add_child(easy_btn)
	
	var medium_btn = Button.new()
	medium_btn.text = "🟡 Médio"
	medium_btn.custom_minimum_size = Vector2(0, 35)
	medium_btn.add_theme_font_override("font", preload("res://Font/tenderness.otf"))
	medium_btn.add_theme_font_size_override("font_size", 14)
	medium_btn.pressed.connect(_on_difficulty_selected.bind("medium"))
	options_container.add_child(medium_btn)
	
	var hard_btn = Button.new()
	hard_btn.text = "🔴 Difícil"
	hard_btn.custom_minimum_size = Vector2(0, 35)
	hard_btn.add_theme_font_override("font", preload("res://Font/tenderness.otf"))
	hard_btn.add_theme_font_size_override("font_size", 14)
	hard_btn.pressed.connect(_on_difficulty_selected.bind("hard"))
	options_container.add_child(hard_btn)
	
	get_tree().paused = true

func show_quiz():
	current_quiz_question = quiz_questions[quiz_difficulty].pick_random()

	var quiz_panel = Panel.new()
	quiz_panel.name = "QuizPanel"
	quiz_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	quiz_panel.visible = true

	# Âncoras do painel (centralizado e com bom espaço)
	quiz_panel.set_anchor(SIDE_LEFT, 0.25)
	quiz_panel.set_anchor(SIDE_RIGHT, 0.75)
	quiz_panel.set_anchor(SIDE_TOP, 0.20)
	quiz_panel.set_anchor(SIDE_BOTTOM, 0.80)

	var gui_layer = get_node("GUILayer/GUI")
	gui_layer.add_child(quiz_panel)

	# Layout raiz com padding
	var root = MarginContainer.new()
	root.name = "QuizRoot"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", 20)
	root.add_theme_constant_override("margin_right", 20)
	root.add_theme_constant_override("margin_top", 16)
	root.add_theme_constant_override("margin_bottom", 16)
	quiz_panel.add_child(root)

	# Coluna principal
	var vbox = VBoxContainer.new()
	vbox.name = "QuizVBox"
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 10) # Aumentei um pouco a separação
	root.add_child(vbox)

	# Pergunta com autowrap e limite de tamanho
	var question_label = Label.new()
	question_label.text = current_quiz_question["question"]
	question_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	question_label.clip_text = true
	question_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# --- MUDANÇA PRINCIPAL AQUI ---
	# Diga ao label para expandir e ocupar o espaço, em vez de encolher
	question_label.size_flags_vertical = Control.SIZE_EXPAND_FILL 
	# Dê a ele 1 "parte" do espaço vertical total
	question_label.size_flags_stretch_ratio = 1.0 
	
	# Ensure the question_label is visible and properly aligned
	question_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	question_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	question_label.custom_minimum_size = Vector2(0, 50) # Set a minimum height for visibility
	question_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	question_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	question_label.autowrap_mode = TextServer.AUTOWRAP_WORD # Ensure text wraps within the label
	
	vbox.add_child(question_label)

	# Opções ajustadas para caberem no painel
	var options_container = GridContainer.new()
	options_container.name = "QuizOptions"
	options_container.columns = 2 # Set two columns for the options
	options_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	options_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	options_container.add_theme_constant_override("separation", 8)
	vbox.add_child(options_container)

	var shuffled_options = current_quiz_question["options"].duplicate()
	shuffled_options.shuffle()
	for option in shuffled_options:
		var option_btn = Button.new()
		option_btn.text = str(option)
		option_btn.custom_minimum_size = Vector2(0, 40) # Set button height
		option_btn.add_theme_font_override("font", preload("res://Font/tenderness.otf"))
		option_btn.add_theme_font_size_override("font_size", 14)
		option_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		option_btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		option_btn.pressed.connect(_on_quiz_answer_selected.bind(option))
		options_container.add_child(option_btn)

	quiz_panel_visible = true
	
func _on_difficulty_selected(difficulty: String):
	quiz_difficulty = difficulty
	# Buscar o painel no caminho correto
	var difficulty_panel = get_node("GUILayer/GUI/DifficultyPanel")
	if difficulty_panel:
		difficulty_panel.queue_free()
	show_quiz()

func _on_quiz_answer_selected(selected_answer):
	# Aceita qualquer tipo de resposta (int, float, String) —
	# normalizamos para string antes de comparar para evitar erros
	# quando a resposta contém símbolos (ex: "%", "×", "²")

	# Buscar o painel no caminho correto e fechá-lo imediatamente
	var quiz_panel = get_node("GUILayer/GUI/QuizPanel")
	if quiz_panel:
		quiz_panel.queue_free()

	quiz_panel_visible = false

	# Normaliza tanto a resposta selecionada quanto a resposta correta
	var normalized_selected = str(selected_answer).strip_edges()
	var normalized_answer = str(current_quiz_question["answer"]).strip_edges()

	if normalized_selected == normalized_answer:
		# Resposta correta - proceder com level up
		proceed_with_levelup()
	else:
		# Resposta errada - não ganha level up
		get_tree().paused = false

func proceed_with_levelup():
	# Animação igual ao level up original
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position",Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

# Ajusta o layout do quiz para garantir que a pergunta nunca exceda o painel
func _finalize_quiz_layout_paths(panel_path: NodePath, label_path: NodePath, options_path: NodePath):
	var quiz_panel: Panel = get_node_or_null(panel_path)
	var question_label: Label = get_node_or_null(label_path)
	var options_container: VBoxContainer = get_node_or_null(options_path)
	if quiz_panel == null or question_label == null or options_container == null:
		return

	# Espaçamento interno do painel
	var side_padding = 15
	var top_padding = 10
	var bottom_padding = 15

	# Largura útil para a pergunta
	var inner_width = max(0, quiz_panel.size.x - (side_padding * 2))
	question_label.size.x = inner_width
	question_label.position.x = side_padding
	question_label.position.y = top_padding

	# Tenta manter a fonte, mas reduz se necessário
	var base_font_size = 16
	var min_font_size = 12
	question_label.add_theme_font_size_override("font_size", base_font_size)

	# Força layout para obter altura natural
	question_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	question_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	question_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Ajusta fonte até caber na área disponível (reserva pelo menos 4 botões x 30 + separações)
	var reserved_for_options = 4 * 30 + 3 * options_container.get_theme_constant("separation") + 20
	var available_height = max(0, quiz_panel.size.y - reserved_for_options - top_padding - bottom_padding)
	var font_size = base_font_size
	for i in range(base_font_size - min_font_size + 1):
		question_label.add_theme_font_size_override("font_size", font_size)
		# Atualiza mínimo de altura após mudança de fonte
		question_label.reset_size()
		await get_tree().process_frame
		var needed = question_label.get_minimum_size().y
		if needed <= available_height:
			break
		font_size -= 1
		if font_size < min_font_size:
			font_size = min_font_size
			question_label.add_theme_font_size_override("font_size", font_size)
			question_label.reset_size()
			await get_tree().process_frame
			break

	# Define altura final da pergunta sem extrapolar
	var final_needed = question_label.get_minimum_size().y
	var final_height = clamp(final_needed, 40, available_height)
	question_label.size.y = final_height

	# Posiciona opções logo abaixo da pergunta, com padding
	options_container.position.x = side_padding
	options_container.position.y = top_padding + final_height + 10
	options_container.size.x = inner_width
	options_container.size.y = max(0, quiz_panel.size.y - options_container.position.y - bottom_padding)


func _on_btn_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")
