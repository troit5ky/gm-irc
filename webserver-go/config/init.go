package config

import (
	"encoding/json"
	"log"
	"os"
)

type (
	OptionStruct struct {
		Token string `json:"token"`
		ChID  string `json:"channelid"`
	}
)

var (
	Option_Example = OptionStruct{
		Token: "null",
		ChID:  "null",
	}

	Option *OptionStruct
)

func Init() {
	defer log.Println("Init config finished!")

	file, err := os.ReadFile("bot.json")
	if err != nil {
		example, _ := json.MarshalIndent(OptionStruct{"your_token", "listen_channel_id"}, "    ", "    ")
		os.WriteFile("bot.json", example, 0644)
		log.Println("Change bot.json")
		os.Exit(0)
	}

	err = json.Unmarshal(file, &Option)

	if err != nil {
		log.Panic(err)
	}
}
