extends CharacterBody2D


@export var speed = 50
@export var nav_agent: NavigationAgent2D

var target_node = null
var home_pos = Vector2.ZERO

func _ready():
	# Grava a posição original(para onde ele vai retornar quando o alvo sair do alcance)
	home_pos = self.global_position
	#$Navigation/RecalculateTimer.start()
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4


func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	
	var axis = to_local(nav_agent.get_next_path_position()).normalized() #retorna vetor normalizado
	velocity = axis * speed
	
	move_and_slide()
	

func recalc_path():
	# Recalcula o caminho, se o alvo existir vai atrás dele, se não, volta para a origem
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = home_pos




func _on_recalculate_timer_timeout():
	# Recalcula a rota a cada X segundos, definidos no $Navigation/RecalculateTimer
	recalc_path()


func _on_aggro_range_area_entered(area):
	# Quando um objeto contendo uma área entra na área de detecção do inimigo o alvo se torna esse objeto
	target_node = area.owner


func _on_de_aggro_range_area_exited(area):
	# Quando o objeto sai da área ele seta o target para null
	if area.owner == target_node:
		target_node = null
