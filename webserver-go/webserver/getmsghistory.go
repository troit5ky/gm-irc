package webserver

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"
	"webserver-go/bot"

	"github.com/bwmarrin/discordgo"
)

func GetMsgHistory(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json")

	var MsgArr []MsgStruct
	limit, err := strconv.Atoi(r.URL.Query().Get("limit"))

	if err != nil {
		limit = 10
	}

	if limit > 100 {
		w.WriteHeader(400)
		fmt.Fprintf(w, "limit должен быть меньше или равен 100!")
		return
	}

	MsgRawArr := bot.GetMsgHistory(limit)
	for _, msg := range MsgRawArr {
		var nickname = msg.Author.Username
		var timestamp int
		var replacer = strings.NewReplacer("%", "", "\\", "")

		tsparse, _ := msg.Timestamp.Parse()
		timestamp = int(tsparse.Unix())

		msg.Content = replacer.Replace(msg.Content)

		if msg.Content == "" {
			msg.Content = "(вложение)"
		}

		if msg.Type == discordgo.MessageTypeReply {
			if len(msg.Mentions) > 0 {
				msg.Content = "[ответ на сообщение @" + msg.Mentions[0].Username + "] " + msg.Content
			} else {
				msg.Content = "[ответ на сообщение] " + msg.Content
			}
		}

		data := MsgStruct{
			Author:    nickname,
			Content:   msg.Content,
			Timestamp: timestamp,
			IsBot:     msg.Author.Bot,
		}
		MsgArr = append(MsgArr, data)
	}

	Resp, err := json.Marshal(MsgArr)
	if err != nil {
		log.Println(err)
	}

	result := string(Resp)
	w.WriteHeader(200)
	fmt.Fprintf(w, result)
}
