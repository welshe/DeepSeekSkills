extends Control

@onready var enter_map_button = $VBoxContainer/EnterMapButton

func _ready():
    enter_map_button.connect("pressed", Callable(self, "_on_enter_map_pressed"))

func _on_enter_map_pressed():
    get_tree().change_scene_to_file("res://scenes/EnemyMap.tscn")