package config

import (
	"encoding/json"
	"io/ioutil"
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

	a, err := ioutil.ReadFile("config/bot.json")

	if err != nil {
		CreateExample()
		log.Println("Change config/bot.json")
		return
	}

	err = json.Unmarshal(a, &Option)

	if err != nil {
		log.Panic(err)
	}
}

func CreateExample() {
	err := os.Mkdir("config", 0755)
	if err != nil {
		log.Println(err)
	}

	a, err := json.MarshalIndent(Option_Example, " ", " ")
	if err != nil {
		log.Println(err)
	}

	ioutil.WriteFile("config/bot.json", a, 0644)
	ioutil.WriteFile("config/bot_example.json", a, 0644)
}
