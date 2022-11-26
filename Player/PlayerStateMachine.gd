extends StateMachine

func _ready():
	_add_state("Idle")
	_add_state("Run")
	_add_state("Slide")
	_add_state("WallSlide")
	_add_state("Dash")
	_add_state("Jump")
	_add_state("Fall")
	_add_state("Kick")
	_add_state("Crouch")
	_add_state("Stealth")
	_add_state("DoubleJump")
	_add_state("Shoot")
	_add_state("DownKick")
	_add_state("Hurt")
	_add_state("Dead")
	_add_state("AirKick")
	call_deferred("_set_state",states.Idle)

func _input(event):
	if !parent.die:
		if [states.Idle,states.Run].has(state):
			if event.is_action_pressed("ui_select"):
				parent.kick=true
				_set_state(states.Kick)
			elif event.is_action_pressed("ui_focus_next") and abs(parent.motion.x)>5 and parent.slideable:
				if parent.diamonds >= 4:
					parent.slideable=false
					parent._slide()
					parent._dash(parent.dashDirection,true)
					parent.dashTimer.start()
					parent.dash=true
					_set_state(states.Slide)
			elif event.is_action_pressed("ui_focus_prev"):
				if parent.diamonds>=6:
					parent.motion.x=0
					parent.shoot=true
					_set_state(states.Shoot)
			if event.is_action_pressed("ui_up"):
				parent._jump(150)
			elif event.is_action_pressed("ui_down"):
				_set_state(states.Crouch)
				parent._crouch()
		elif state==states.DoubleJump:
			if event.is_action_pressed("ui_focus_next") and parent.dashable:
				if parent.diamonds >=4:
					parent.sprite.rotation_degrees=0
					parent._dash(parent.dashDirection,false)
					parent.dashable=false
					parent.dash=true
					_set_state(states.Dash)
			elif event.is_action_pressed("ui_down"):
				if parent.diamonds>=5 and parent.dowcount == 1:
					parent.dowcount = 0
					parent.downKick=true
					_set_state(states.DownKick)
		elif [states.Jump,states.Fall].has(state):
			if event.is_action_pressed("ui_select"):
				parent.kick=true
				_set_state(states.AirKick)
			if event.is_action_pressed("ui_focus_next") and parent.dashable:
				if parent.diamonds>=4:
					parent._dash(parent.dashDirection,false)
					parent.dashable=false
					parent.dash=true
					_set_state(states.Dash)
			elif event.is_action_pressed("ui_up"):
				if parent.diamonds>=3:
					_set_state(states.DoubleJump)
					parent._doubleJump(150)
			elif event.is_action_pressed("ui_down"):
				if parent.diamonds>=5 and parent.dowcount == 1:
					parent.dowcount = 0
					parent.downKick=true
					_set_state(states.DownKick)
			if state==states.Jump:
				if event.is_action_released("ui_up"):
					parent._jump(parent.motion.y/2)
		elif state==states.WallSlide:
			if event.is_action_pressed("ui_up"):
				parent.gravity = 500
				parent._wallJump(100)
			elif event.is_action_pressed("ui_left") and parent._rightWall():
				parent.wallSlideTimer.start()
			elif event.is_action_pressed("ui_right") and parent._leftWall():
				parent.wallSlideTimer.start()
			if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
				parent.wallSlideTimer.stop()
		elif [states.Stealth,states.Crouch].has(state):
			if event.is_action_released("ui_down"):
				parent.crouched=false
			elif event.is_action_pressed("ui_down"):
				parent.crouched=true

func _state_logic(delta):
	if !parent.die:
		var direction=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
		parent._camera(direction)
		if ![states.WallSlide,states.Dash,states.Kick,states.Slide,states.Kick,states.Shoot,states.AirKick].has(state):
			parent._direction(direction)
		if [states.Idle,states.Run,states.Crouch,states.Stealth].has(state):
			if parent.dashable==false:
				parent.dashable=true
			if state==states.Run:
				if !parent.footSound.playing:
					parent.footSound.play()
			if direction !=0:
				parent.side=direction
			parent._walk(direction)
		elif [states.DoubleJump,states.Jump,states.Fall,states.DownKick,states.AirKick].has(state):
			parent._air(direction)
			if [states.DoubleJump,states.DownKick].has(state):
				parent.sprite.rotation_degrees+=30*parent.side
		elif state==states.Shoot:
			parent._bullet()
	else:
		if state!=states.Dead:
			parent.motion.x=0
			_set_state(states.Dead)
	parent._physics(parent.gravity,delta)

func _get_transition(delta):
	if parent.dead:
		if state!=states.Dead:
			return states.Dead
	match state:
		states.Idle:
			if !parent.is_on_floor():
				if parent.motion.y>1:
					return states.Fall
				else:
					return states.Jump
			elif parent.motion.x!=0:
				return states.Run
		states.Run:
			if !parent.is_on_floor():
				if parent.motion.y>0:
					return states.Fall
				else:
					return states.Jump
			elif parent.motion.x==0:
				return states.Idle
		states.Jump:
			if parent.is_on_floor():
				return states.Idle
			elif parent.motion.y>0:
				return states.Fall
		states.DoubleJump:
			if parent.is_on_floor():
				parent.sprite.rotation_degrees=0
				return states.Idle
			elif (parent._leftWall() or parent._rightWall()) and !Input.is_action_pressed("ui_down"):
				if parent.diamonds>=2:
					parent._wallSlide()
					parent.sprite.rotation_degrees=0
					return states.WallSlide
		states.Crouch:
			if !parent._roof():
				if !parent.crouched:
					parent._uncrouch()
					return states.Idle
				elif !parent.is_on_floor():
					parent._uncrouch()
					return states.Fall
			if parent.motion.x!=0:
				return states.Stealth
		states.Stealth:
			if !parent._roof():
				if !parent.crouched:
					parent._uncrouch()
					return states.Idle
				elif !parent.is_on_floor():
					parent._uncrouch()
					return states.Fall
			if parent.motion.x==0:
				return states.Crouch
		states.Kick:
			if !parent.kick:
				if parent.is_on_floor():
					return states.Idle
				else:
					if parent.motion.y>0:
						return states.Fall
					else:
						return states.Jump
		states.AirKick:
			if !parent.kick:
				if parent.is_on_floor():
					return states.Idle
				else:
					if parent.motion.y>0:
						return states.Fall
					else:
						return states.Jump
		states.Shoot:
			if !parent.shoot:
				if parent.is_on_floor():
					parent.bull=false
					return states.Idle
				else:
					if parent.motion.y>0:
						parent.bull=false
						return states.Fall
					else:
						parent.bull=false
						return states.Jump
		states.DownKick:
			if!parent.downKick:
				if parent.is_on_floor():
					parent.sprite.rotation_degrees=0
					return states.Idle
				else:
					return states.DoubleJump
		states.Fall:
			if parent.is_on_floor():
				return states.Idle
			elif (parent._leftWall() or parent._rightWall()) and !Input.is_action_pressed("ui_down"):
				if parent.diamonds>=2:
					parent._wallSlide()
					return states.WallSlide
			else:
				if parent.motion.y<=0:
					return states.Jump
		states.WallSlide:
			if parent.is_on_floor() or parent.diamonds<1:
				parent.gravity = 500
				return states.Idle
			else:
				if (parent._leftWall()==false and parent._rightWall() == false) or Input.is_action_pressed("ui_down"):
					if parent.motion.y<=0:
						parent.gravity = 500
						return states.Jump
					elif parent.motion.y>0:
						parent.gravity = 500
						return states.Fall
		states.Dash:
			if !parent.dash:
				if parent.is_on_floor():
					parent._reset_attack()
					return states.Idle
				else:
					if parent.motion.y>0:
						parent._reset_attack()
						return states.Fall
					else:
						parent._reset_attack()
						return states.Jump
		states.Slide:
			if !parent.dash:
				if !parent._roof():
					if !parent.crouched:
						parent._uncrouch()
						return states.Idle
					elif !parent.is_on_floor():
						if parent._leftWall() or parent._rightWall():
							if parent.diamonds>=2:
								parent.dash=false
								parent._wallSlide()
								parent._uncrouch()
								return states.WallSlide
						parent.dash=false
						parent._uncrouch()
						return states.Fall
				if parent.motion.x==0:
					return states.Crouch
				elif parent.motion.x!=0:
					return states.Stealth
			elif !parent.is_on_floor():
				parent.slideable=true
				parent.dashTimer.stop()
				parent.dash=false
				parent._uncrouch()
				return states.Fall
		states.Hurt:
			pass
	return null
func _enter_state(new_state,old_state):
	match state:
		states.Idle:
			parent.footSound.stop()
			parent.dowcount=1
			parent.plAnimation.play("Idle")
		states.Run:
			parent.dowcount=1
			parent._RunDust()
			parent.runDustTimer.start()
			parent.plAnimation.play("Run")
		states.Fall:
			parent.footSound.stop()
			parent.plAnimation.play("Fall")
		states.Jump:
			parent.footSound.stop()
			parent.jumpSound.play()
			if [states.Idle,states.Run].has(old_state):
				parent.squash.play("Jump")
				parent._JumpDust()
			parent.plAnimation.play("Jump")
		states.DoubleJump:
			parent.doubleJumpSound.play()
			parent.plAnimation.play("DoubleJump")
		states.WallSlide:
			parent.footSound.stop()
			parent.wallDustTimer.start()
			parent.plAnimation.play("WallSlide")
		states.Crouch:
			parent.footSound.stop()
			parent.plAnimation.play("Crouch")
		states.Stealth:
			parent.walkSpeed=20
			parent.walkAcc=100
			parent.footSound.stop()
			parent.plAnimation.play("Stealth")
		states.Dash:
			parent.footSound.stop()
			parent.dashSound.play()
			parent._DashEffect()
			parent.dashEffectTimer.start()
			parent.plAnimation.play("AirKick")
		states.Slide:
			parent.footSound.stop()
			parent.slideSound.play()
			parent.kickShape.set_deferred("disabled",false)
			parent._SlideDust()
			parent.slideDustTimer.start()
			parent.plAnimation.play("Slide")
		states.Kick:
			parent.footSound.stop()
			parent.attackSound.play()
			if parent.motion.x!=0:
				parent.plAnimation.play("AirKick")
			else:
				parent.plAnimation.play("Kick")
		states.AirKick:
			parent.footSound.stop()
			parent.attackSound.play()
			parent.plAnimation.play("AirKick")
		states.DownKick:
			parent.downSound.play()
			parent.attackSound.play()
			parent.downTimer.start()
			parent.plAnimation.play("DownKick")
		states.Shoot:
			parent.footSound.stop()
			parent.attackSound.play()
			parent.shootSound.play()
			parent.plAnimation.play("Shoot")
		states.Dead:
			parent.footSound.stop()
			parent.motion.x=0
			parent.plAnimation.play("Death")

func _exit_state(old_state,new_state):
	match old_state:
		states.DownKick:
			parent.sprite.rotation_degrees=0
			parent.spawned=false
		states.WallSlide:
			parent.wallDustTimer.stop()
		states.Run:
			parent.runDustTimer.stop()
		states.Fall:
			if [states.Idle,states.Run].has(new_state):
				parent.landSound.play()
				parent.squash.play("Land")
				parent._LandDust()
		states.DoubleJump:
			parent.sprite.rotation_degrees=0
			if [states.Idle,states.Run].has(new_state):
				parent.landSound.play()
				parent.squash.play("Land")
				parent._LandDust()
		states.Slide:
			parent.kickShape.set_deferred("disabled",true)
			parent.slideDustTimer.stop()
		states.Dash:
			parent.motion.x=clamp(parent.motion.x,-parent.walkSpeed,parent.walkSpeed)
			parent.dashEffectTimer.stop()
		states.Run:
			parent.footSound.stop()
