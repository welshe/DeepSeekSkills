extends Control

@onready var start_button = $VBoxContainer/StartButton

func _ready():
    start_button.connect("pressed", Callable(self, "_on_start_pressed"))

func _on_start_pressed():
    get_tree().change_scene_to_file("res://scenes/Tavern.tscn")