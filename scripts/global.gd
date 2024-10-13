extends Node2D


var interactables: Array[Interactable] = []

var textbox: TextBox = null
var player_character: Controllable = null
var question_block: QuestionBlock = null
var focus_shader: Material = null
var tint_shader: Material = null
var logging: bool = false
