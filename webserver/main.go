package main

import (
	"log"

	"./bot"
	"./config"
	"./webserver"
)

func main() {
	log.Println("Init config...")
	config.Init()

	log.Println("Init bot...")
	bot.Init()

	log.Println("Init webserver...")
	webserver.Init()
}
