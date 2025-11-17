extends Node


const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
const UPGRADES = {
	"icespear1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Orbe de poder",
		"details": "Uma orbe é arremessada em um inimigo aleatório",
		"level": "Nível: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"icespear2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Orbe de poder",
		"details": "Uma orbe é arremessada em um inimigo aleatório",
		"level": "Nível: 2",
		"prerequisite": ["icespear1"],
		"type": "weapon"
	},
	"icespear3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Orbe de poder",
		"details": "Uma orbe atravessa inimigos e causam +3 de dano",
		"level": "Nível: 3",
		"prerequisite": ["icespear2"],
		"type": "weapon"
	},
	"icespear4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Lança de Gelo",
		"details": "2 Lanças de Gelo adicionais são arremessadas",
		"level": "Nível: 4",
		"prerequisite": ["icespear3"],
		"type": "weapon"
	},
	"javelin1": {
		"icon": WEAPON_PATH + "lapis voador 32.png",
		"displayname": "Lápis Voador",
		"details": "Um lápis voador te segue atacando inimigos em linha reta",
		"level": "Nível: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"javelin2": {
		"icon": WEAPON_PATH + "lapis voador 32.png",
		"displayname": "Lápis voador",
		"details": "O lápis voador ataca um inimigo adicional por ataque",
		"level": "Nível: 2",
		"prerequisite": ["javelin1"],
		"type": "weapon"
	},
	"javelin3": {
		"icon": WEAPON_PATH + "lapis voador 32.png",
		"displayname": "Lápis voador",
		"details": "O lápis voador ataca mais um inimigo adicional por ataque",
		"level": "Nível: 3",
		"prerequisite": ["javelin2"],
		"type": "weapon"
	},
	"javelin4": {
		"icon": WEAPON_PATH + "lapis voador 32.png",
		"displayname": "Lápis voador",
		"details": "O lápis voador causa +5 de dano e 20% mais repulsão",
		"level": "Nível: 4",
		"prerequisite": ["javelin3"],
		"type": "weapon"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "Um tornado é criado e se move na direção do jogador",
		"level": "Nível: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "Um Tornado adicional é criado",
		"level": "Nível: 2",
		"prerequisite": ["tornado1"],
		"type": "weapon"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "O tempo de recarga do Tornado é reduzido em 0.5 segundos",
		"level": "Nível: 3",
		"prerequisite": ["tornado2"],
		"type": "weapon"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "Um tornado adicional é criado e a repulsão aumenta em 25%",
		"level": "Nível: 4",
		"prerequisite": ["tornado3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduz o dano recebido em 1 ponto",
		"level": "Nível: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduz o dano em mais 1 ponto adicional",
		"level": "Nível: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduz o dano em mais 1 ponto adicional",
		"level": "Nível: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armadura",
		"details": "Reduz o dano em mais 1 ponto adicional",
		"level": "Nível: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidade",
		"details": "Velocidade de movimento aumentada em 5%",
		"level": "Nível: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidade",
		"details": "Velocidade aumentada em mais 5%",
		"level": "Nível: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidade",
		"details": "Velocidade aumentada em mais 5%",
		"level": "Nível: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Velocidade",
		"details": "Velocidade aumentada em mais 5%",
		"level": "Nível: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Grimório",
		"details": "Aumenta o tamanho dos feitiços em 10%",
		"level": "Nível: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Grimório",
		"details": "Aumenta o tamanho dos feitiços em mais 10%",
		"level": "Nível: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Grimório",
		"details": "Aumenta o tamanho dos feitiços em mais 10%",
		"level": "Nível: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Grimório",
		"details": "Aumenta o tamanho dos feitiços em mais 10%",
		"level": "Nível: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergaminho",
		"details": "Reduz o tempo de recarga dos feitiços em 5%",
		"level": "Nível: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergaminho",
		"details": "Reduz o tempo de recarga em mais 5%",
		"level": "Nível: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergaminho",
		"details": "Reduz o tempo de recarga em mais 5%",
		"level": "Nível: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Pergaminho",
		"details": "Reduz o tempo de recarga em mais 5%",
		"level": "Nível: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Anel",
		"details": "Seus feitiços lançam 1 ataque adicional",
		"level": "Nível: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Anel",
		"details": "Seus feitiços lançam mais 1 ataque adicional",
		"level": "Nível: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Comida",
		"details": "Cura 20 de vida e aumenta vida máxima em 5",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
