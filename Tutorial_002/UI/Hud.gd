extends CanvasLayer

onready var healthSprite1: = $HealthSprite1
onready var healthSprite2: = $HealthSprite2
onready var healthSprite3: = $HealthSprite3
onready var levelId: = $LevelIdentifier

export(Texture) var emptyHeart
export(Texture) var halfHeart
export(Texture) var fullHeart

func update_message_text(levelNumber):
	levelId.text = "Level " + str(levelNumber)

func update_hud_health(playerHealth):
	match playerHealth:
		0: 
			emptyHeart(healthSprite1)
			emptyHeart(healthSprite2)
			emptyHeart(healthSprite3)
		1: 
			halfHeart(healthSprite1)
			emptyHeart(healthSprite2)
			emptyHeart(healthSprite3)
		2: 
			fullHeart(healthSprite1)
			emptyHeart(healthSprite2)
			emptyHeart(healthSprite3)
		3: 
			fullHeart(healthSprite1)
			halfHeart(healthSprite2)
			emptyHeart(healthSprite3)
		4: 
			fullHeart(healthSprite1)
			fullHeart(healthSprite2)
			emptyHeart(healthSprite3)
		5: 
			fullHeart(healthSprite1)
			fullHeart(healthSprite2)
			halfHeart(healthSprite3)
		6: 
			
			fullHeart(healthSprite1)
			fullHeart(healthSprite2)
			fullHeart(healthSprite3)
	if(playerHealth < 0):
		emptyHeart(healthSprite1)
		emptyHeart(healthSprite2)
		emptyHeart(healthSprite3)

func emptyHeart(hpSprite):
	hpSprite.animation = "EmptyHeart"

func halfHeart(hpSprite):
	hpSprite.animation = "HalfHeart"

func fullHeart(hpSprite):
	hpSprite.animation = "FullHeart"	

