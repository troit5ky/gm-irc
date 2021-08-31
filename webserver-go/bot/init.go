package bot

import (
	"log"

	"webserver-go/config"

	"github.com/bwmarrin/discordgo"
)

var (
	Session *discordgo.Session
)

func Init() {
	defer log.Println("Init bot finished!")

	s, err := discordgo.New("Bot " + config.Option.Token)
	if err != nil {
		log.Fatal(err)
	}

	Session = s
}

func GetMsgHistory(limit int) []*discordgo.Message {
	Msgs, err := Session.ChannelMessages(config.Option.ChID, limit, "", "", "")
	if err != nil {
		log.Println(err)
	}

	return Msgs
}
