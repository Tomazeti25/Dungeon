extends Node

var silver_key_obtained = false  # Chave prateada obtida
var golden_key_obtained = false  # Chave dourada obtida

export (NodePath) var enemy_1_path
export (NodePath) var enemy_2_path
export (NodePath) var enemy_3_path

export (NodePath) var silver_key_path  # O path da chave prateada

var defeated_special_enemies = 0

export var enemies_needed_for_silver_key = 3  # Defina o valor no Inspector

signal silver_key_appeared

var special_enemies = []

func _ready():
	special_enemies.append(get_node(enemy_1_path))
	special_enemies.append(get_node(enemy_2_path))
	special_enemies.append(get_node(enemy_3_path))
	
	var silver_key = get_node(silver_key_path)
	silver_key.visible = false  # Deixe a chave invisível inicialmente

func enemy_defeated(enemy):
	if special_enemies.has(enemy):
		defeated_special_enemies += 1
		print("Inimigos especiais derrotados:", defeated_special_enemies)
		
		if defeated_special_enemies >= enemies_needed_for_silver_key and !silver_key_obtained:
			silver_key_obtained = true
			print("Chave prateada apareceu!")
			var silver_key = get_node(silver_key_path)
			silver_key.visible = true  # Torna a chave visível
			silver_key.position = Vector2(-240, 40)  # Alterar a posição da chave conforme necessário
			emit_signal("silver_key_appeared") 
