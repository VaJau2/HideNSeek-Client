extends Node

#-----
#настроен на синглтон "G" через интерфейс движка
#-----

var settings = GameSettings.new()
var network = null
var player = null
var bell = null
var paused = false
