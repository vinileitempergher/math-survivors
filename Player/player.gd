extends CharacterBody2D


var movement_speed = 800.0
var hp = 80
var maxhp = 80
var last_movement = Vector2.UP
var time = 0

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

#Signal
signal playerdeath

#QUIZ SYSTEM
var quiz_questions = {
	"easy": [
		# Porcentagem
		{"question": "Fácil – Porcentagem: 25% de 200 = ?", "answer": 50, "options": [40, 50, 60, 75]},
		{"question": "Fácil – Porcentagem: 10% de 150 = ?", "answer": 15, "options": [10, 12, 15, 20]},
		# Notação científica (resultados inteiros)
		{"question": "Fácil – Notação científica: 3 × 10^2 = ?", "answer": 300, "options": [30, 300, 3000, 200]},
		{"question": "Fácil – Notação científica: 7 × 10^1 = ?", "answer": 70, "options": [7, 17, 70, 700]},
		# Potenciação
		{"question": "Fácil – Potenciação: 2^3 = ?", "answer": 8, "options": [6, 8, 9, 12]},
		{"question": "Fácil – Potenciação: 5^2 = ?", "answer": 25, "options": [20, 24, 25, 30]},
		# Raiz
		{"question": "Fácil – Raiz quadrada: √81 = ?", "answer": 9, "options": [7, 8, 9, 10]},
		{"question": "Fácil – Raiz quadrada: √49 = ?", "answer": 7, "options": [5, 6, 7, 8]},
		# Área e perímetro
		{"question": "Fácil – Área: retângulo 5 × 3 = ?", "answer": 15, "options": [12, 15, 18, 20]},
		{"question": "Fácil – Perímetro: quadrado de lado 6 = ?", "answer": 24, "options": [20, 22, 24, 26]},
		# Números inteiros
		{"question": "Fácil – Inteiros: (-7) + 12 = ?", "answer": 5, "options": [3, 4, 5, 6]}
	],
	"medium": [
		# Porcentagem
		{"question": "Médio – Porcentagem: 30% de 250 = ?", "answer": 75, "options": [70, 72, 75, 80]},
		{"question": "Médio – Porcentagem: 15% de 240 = ?", "answer": 36, "options": [30, 32, 36, 40]},
		# Notação científica (expoente inteiro e valores inteiros)
		{"question": "Médio – Notação científica: Em 5 × 10^n = 5000, n = ?", "answer": 3, "options": [2, 3, 4, 5]},
		{"question": "Médio – Notação científica: 6 × 10^3 = ?", "answer": 6000, "options": [600, 6000, 60000, 600000]},
		# Potenciação
		{"question": "Médio – Potenciação: 3^4 = ?", "answer": 81, "options": [27, 64, 81, 96]},
		{"question": "Médio – Potenciação: 10^5 ÷ 10^3 = ?", "answer": 100, "options": [10, 100, 1000, 10000]},
		# Raiz
		{"question": "Médio – Raiz quadrada: √225 = ?", "answer": 15, "options": [13, 14, 15, 16]},
		# Área e perímetro
		{"question": "Médio – Área: triângulo de base 12 e altura 8 = ?", "answer": 48, "options": [36, 48, 60, 96]},
		{"question": "Médio – Perímetro: retângulo 9 × 7 = ?", "answer": 32, "options": [28, 30, 32, 34]},
		# Números inteiros
		{"question": "Médio – Inteiros: (-12) - (-7) = ?", "answer": -5, "options": [-19, -5, 5, 7]}
	],
	"hard": [
		# Porcentagem
		{"question": "Difícil – Porcentagem: Aumentar 200 em 15% resulta em?", "answer": 230, "options": [215, 220, 230, 240]},
		{"question": "Difícil – Porcentagem: Desconto de 25% em 360 resulta em?", "answer": 270, "options": [240, 260, 270, 300]},
		# Notação científica (evitando decimais no resultado)
		{"question": "Difícil – Notação científica: Em 3 × 10^n = 30000, n = ?", "answer": 4, "options": [3, 4, 5, 6]},
		{"question": "Difícil – Notação científica: 4 × 10^4 + 3 × 10^4 = ?", "answer": 70000, "options": [40000, 7000, 70000, 700000]},
		# Potenciação
		{"question": "Difícil – Potenciação: 2^5 × 2^3 = ?", "answer": 256, "options": [128, 200, 256, 512]},
		{"question": "Difícil – Potenciação: (-4)^3 = ?", "answer": -64, "options": [-128, -64, 64, 256]},
		# Raiz
		{"question": "Difícil – Raiz: √144 + √81 = ?", "answer": 21, "options": [20, 21, 22, 24]},
		# Área e perímetro
		{"question": "Difícil – Área: paralelogramo base 14 e altura 9 = ?", "answer": 126, "options": [96, 112, 126, 140]},
		{"question": "Difícil – Perímetro: retângulo 13 × 9 = ?", "answer": 44, "options": [40, 42, 44, 46]},
		# Números inteiros
		{"question": "Difícil – Inteiros: |−18| − |−7| = ?", "answer": 11, "options": [9, 10, 11, 12]}
	]
}

var current_quiz_question = {}
var quiz_difficulty = ""
var quiz_panel_visible = false

func _ready():
	upgrade_character("icespear1")
	attack()
	set_expbar(experience, calculate_experiencecap())
	_on_hurt_box_hurt(0,0,0)
	

func _physics_process(_delta):
	movement()

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
	if hp <= 0:
		death()

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
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,maxhp)
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
	if time >= 300:
		lblResult.text = "You Win"
		sndVictory.play()
	else:
		lblResult.text = "You Lose"
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

func _on_quiz_answer_selected(selected_answer: int):
	# Buscar o painel no caminho correto
	var quiz_panel = get_node("GUILayer/GUI/QuizPanel")
	if quiz_panel:
		quiz_panel.queue_free()
	
	quiz_panel_visible = false
	
	if selected_answer == current_quiz_question["answer"]:
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
