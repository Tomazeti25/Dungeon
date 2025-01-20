extends KinematicBody2D

var max_health = 3
var current_health = max_health
var is_special_enemy = false  

onready var game_manager = get_node("/root/GameManager")

func take_damage(damage):
    current_health -= damage
    if current_health <= 0:
        die()

func die():
    print("Inimigo morto!")
    
    
    if is_special_enemy:
        game_manager.enemy_defeated(self)  
        
    queue_free()
