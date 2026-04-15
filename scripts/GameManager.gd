extends Node3D

enum State {BUILD, WAVE}

@onready var map = $Map
@onready var nav_region = $Map/NavigationRegion3D
@onready var crystal = $Crystal
@onready var player = $Player
@onready var state_label = $HUD/VBoxContainer/StateLabel
@onready var wave_label = $HUD/VBoxContainer/WaveLabel
@onready var health_label = $HUD/VBoxContainer/HealthLabel

var enemy_scene = preload("res://scenes/Enemy.tscn")
var tower_scene = preload("res://scenes/Tower.tscn")

var current_state = State.BUILD
var wave_number = 0
var enemies = []

func _ready():
    nav_region.bake_navigation_mesh()
    crystal.connect("health_changed", Callable(self, "_on_crystal_health_changed"))
    update_hud()

func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and current_state == State.BUILD:
        var camera = player.get_node("Camera3D")
        var from = camera.project_ray_origin(event.position)
        var to = from + camera.project_ray_normal(event.position) * 1000
        var space = get_world_3d().direct_space_state
        var query = PhysicsRayQueryParameters3D.create(from, to)
        var result = space.intersect_ray(query)
        if result:
            place_tower(result.position)
    elif event.is_action_pressed("start_wave") and current_state == State.BUILD:
        start_wave()

func start_wave():
    current_state = State.WAVE
    wave_number += 1
    update_hud()
    # Spawn enemies for the wave
    var enemy_count = wave_number * 5
    # Spawn enemies over time to make waves feel dynamic
    for i in range(enemy_count):
        var pos = Vector3(randf_range(-20, 20), 0, randf_range(-20, 20))
        spawn_enemy(pos)
        await get_tree().create_timer(0.35)

func spawn_enemy(pos: Vector3):
    var enemy = enemy_scene.instantiate()
    enemy.global_position = pos
    # Give enemy a reference to the crystal node so it can damage it on arrival
    if enemy.has_method("set_target_node"):
        enemy.set_target_node(crystal)
    else:
        enemy.set_target(crystal.global_position)
    add_child(enemy)
    enemies.append(enemy)
    enemy.connect("tree_exited", Callable(self, "_on_enemy_died").bind(enemy))

func _on_enemy_died(enemy):
    enemies.erase(enemy)
    if enemies.size() == 0 and current_state == State.WAVE:
        current_state = State.BUILD
        update_hud()

func place_tower(pos: Vector3):
    # Snap placement to a 1-unit grid for tidier layouts
    var snapped = Vector3(round(pos.x), round(pos.y), round(pos.z))
    var tower = tower_scene.instantiate()
    tower.global_position = snapped
    add_child(tower)

func update_hud():
    if current_state == State.BUILD:
        state_label.text = "Build Phase - Press G to Start Wave"
    else:
        state_label.text = "Wave In Progress"
    wave_label.text = "Wave: " + str(wave_number)
    health_label.text = "Crystal Health: " + str(crystal.health)

func _on_crystal_health_changed(new_health):
    update_hud()