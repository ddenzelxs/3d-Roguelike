extends CanvasLayer

@onready var video = $VideoStreamPlayer
signal video_finished

func _ready():
	hide()
	video.finished.connect(_on_video_finished)

func play_video():
	show()
	video.play()

func _on_video_finished():
	hide()
	video_finished.emit()
