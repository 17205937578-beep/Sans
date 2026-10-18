extends CharacterBody2D
## 敌人：随机移动 + 追踪玩家（GitHub 任务 #3）
## 完成标准：
##   - 敌人随机漫游
##   - 玩家进入 CHASE_DISTANCE 距离时，敌人转向追踪玩家
##   - 追踪速度不超过 CHASE_SPEED
##   - 玩家远离后恢复随机移动
##   - 敌人不攻击

## 敌人移动速度（固定，与玩家速度无关）
const ENEMY_SPEED := 210.0
## 开始追踪玩家的距离（像素）
const CHASE_DISTANCE := 200.0
## 漫游方向更换间隔（秒）
const WANDER_DIRECTION_CHANGE := 2.0

var _player: Node2D
var _wander_direction := Vector2.ZERO
var _wander_timer := 0.0

func _ready() -> void:
	# 玩家与敌人在主场景中是兄弟节点
	_player = get_node_or_null("../Player") as Node2D
	_pick_new_wander_direction()

func _physics_process(delta: float) -> void:
	var distance_to_player := INF
	if _player != null:
		distance_to_player = global_position.distance_to(_player.global_position)

	if distance_to_player < CHASE_DISTANCE:
		# 追踪玩家（不攻击，只靠近），速度固定 210
		var direction := (_player.global_position - global_position).normalized()
		velocity = direction * ENEMY_SPEED
	else:
		# 随机漫游：每隔一段时间换一个方向，速度固定 210
		_wander_timer -= delta
		if _wander_timer <= 0.0:
			_pick_new_wander_direction()
		velocity = _wander_direction * ENEMY_SPEED

	move_and_slide()

func _pick_new_wander_direction() -> void:
	_wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	_wander_timer = WANDER_DIRECTION_CHANGE
