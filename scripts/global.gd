extends Node2D


var interactables: Array[Interactable] = []

var textbox: TextBox = null
var interacting = null
var interaction_target = null
var game: Node2D = null

var player_character: Controllable = null
var question_block: QuestionBlock = null
var focus_shader: Material = null
var tint_shader: Material = null
var logging: bool = false


func set_interaction_target(interactable: Interactable):
	if interactable != interaction_target:
		if interactable != null:
			interactable.indicate_interaction(true)
		if interaction_target != null:
			interaction_target.indicate_interaction(false)
		interaction_target = interactable
