class_name Interactable

extends Node2D

# var num_interactions = 0

func _ready() -> void:
	Global.interactables.append(self)

func interact() -> void:
	pass

func indicate_interaction(_flag: bool) -> void:
	pass