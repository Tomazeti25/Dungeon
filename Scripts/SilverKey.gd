extends Area2D

onready var game_manager = get_node("/root/GameManager")

func _ready():
    game_manager.connect("silver_key_appeared", self, "_on_silver_key_appeared")

    self.visible = false

func _on_silver_key_appeared():
    self.visible = true
    print("Chave prateada apareceu!")
