extends KinematicBody2D

# Configurações de patrulha variáveis para cada inimigo
export var patrol_start = Vector2(420, 0)  # Posição inicial da patrulha (configurável no Inspector)
export var patrol_end = Vector2(320, 0)    # Posição final da patrulha (configurável no Inspector)
export var patrol_speed = 100              # Velocidade de patrulha (configurável no Inspector)
export var damage = 1                      # Dano causado ao jogador por colisão
export var max_health = 3                  # Vida máxima do inimigo
var current_health = max_health           # Vida atual do inimigo

# Variáveis internas
var moving_to_end = true
var velocity = Vector2()

func _ready():
    # Verifique se o nó Area2D está presente antes de tentar conectar o sinal
    var area2d = $Area2D  # Acesse o nó Area2D
    if area2d:
        area2d.connect("body_entered", self, "_on_body_entered")
    else:
        print("Erro: No 'Area2D' não encontrado! Verifique se o nó está presente.")

func _physics_process(delta):
    patrol()
    move_and_slide(velocity)

func patrol():
    # Define o alvo atual com base na direção do movimento
    var target = patrol_end if moving_to_end else patrol_start
    velocity = (target - global_position).normalized() * patrol_speed

    # Troca de direção ao alcançar o ponto de patrulha
    if global_position.distance_to(target) < 5:
        moving_to_end = not moving_to_end

func _on_body_entered(body):
    # Verifica se o objeto colidido é o jogador
    if body.name == "Player":  # Substitua "Player" pelo nome exato do nó do jogador na cena
        body.take_damage(damage)
        print("Jogador tomou dano do inimigo!")

# Função para o inimigo tomar dano
func take_damage(damage):
    current_health -= damage
    print("Inimigo tomou dano:", damage, "Vida restante:", current_health)
    
    if current_health <= 0:
        die()

# Função para eliminar o inimigo quando a vida chega a zero
func die():
    print("Inimigo morto!")
    queue_free()  # Remove o inimigo da cena
