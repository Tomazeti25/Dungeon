extends KinematicBody2D

var velocity = Vector2()
var speed = 200

onready var animation_player = $AnimationPlayer

enum PlayerState { IDLE, WALK, DAMAGE }
var state = PlayerState.IDLE

var facing_direction = "right"

var max_health = 3
var current_health = max_health

func _ready():
    if animation_player:
        animation_player.play("Idle_" + facing_direction)
    else:
        print("Erro: AnimationPlayer não encontrado!")

    print("Vida inicial do jogador:", current_health)

func _physics_process(delta):
    handle_input()
    move_and_slide(velocity)
    update_animation()

func handle_input():
    velocity = Vector2()  

    if Input.is_action_pressed("up"):
        velocity.y -= speed
    if Input.is_action_pressed("down"):
        velocity.y += speed
    if Input.is_action_pressed("left"):
        velocity.x -= speed
        facing_direction = "left"  
    if Input.is_action_pressed("right"):
        velocity.x += speed
        facing_direction = "right"  

    velocity = velocity.normalized() * speed

    if velocity.length() > 0:
        state = PlayerState.WALK
    else:
        state = PlayerState.IDLE

func update_animation():
    var suffix = "_" + facing_direction  

    match state:
        PlayerState.IDLE:
            if animation_player.current_animation != "Idle" + suffix:
                animation_player.play("Idle" + suffix)
        PlayerState.WALK:
            if animation_player.current_animation != "Walk" + suffix:
                animation_player.play("Walk" + suffix)
        PlayerState.DAMAGE:
            if animation_player.current_animation != "Damage" + suffix:
                animation_player.play("Damage" + suffix)

func take_damage(damage):
    if state != PlayerState.DAMAGE:  
        current_health -= damage
        print("Jogador tomou dano:", damage, "Vida restante:", current_health)
        
        if current_health <= 0:
            die()  
        else:
            state = PlayerState.DAMAGE  

func die():
    print("Jogador morreu!")
    queue_free()  

func heal(amount):
    current_health += amount
    if current_health > max_health:
        current_health = max_health
    print("Jogador curado:", amount, "Vida atual:", current_health)

func _on_body_entered(body):
    if body.name == "Enemy":  
        take_damage(1)  
        print("Colisão com inimigo detectada!")
