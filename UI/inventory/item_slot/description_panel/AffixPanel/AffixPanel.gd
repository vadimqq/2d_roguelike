extends PanelContainer

const AFFIX_ITEM_CLASS = preload("res://Autoload/AffixManager/AffixItem.gd")

onready var title = $HBoxContainer/Title
onready var tier = $Tier
onready var value = $HBoxContainer/Value

const t_1_color = Color(0.76, 0.28, 0.11, 1)
const t_2_color = Color(0.76, 0.28, 0.11, 1)
const t_3_color = Color(0.76, 0.28, 0.11, 1)
const t_4_color = Color(0.76, 0.28, 0.11, 1)


func initialize(affix: AFFIX_ITEM_CLASS):
	title.text = affix.title
	tier.text = "T" + str(affix.tier)
	value.text = "+" + str(affix.value) + "%"
