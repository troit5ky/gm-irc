package webserver

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"../bot"
)

type (
	MsgStruct struct {
		Author    string `json:"author"`
		Content   string `json:"content"`
		Timestamp int    `json:"timestamp"`
	}
)

var (
	MsgArr [10]MsgStruct
)

func Init() {
	log.Println("Webserver started!")

	http.HandleFunc("/getmsghistory", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Add("Content-Type", "application/json")

		MsgRawArr := bot.GetMsgHistory()
		for i, msg := range MsgRawArr {
			if msg.Author.Bot {
				msg.Author.Username = "BOT"
			}

			tsparse, _ := msg.Timestamp.Parse()
			ts := int(tsparse.Unix())
			MsgArr[i] = MsgStruct{Author: msg.Author.Username, Content: msg.Content, Timestamp: ts}
		}

		Resp, err := json.Marshal(MsgArr)
		if err != nil {
			log.Println(err)
		}

		fmt.Fprintf(w, string(Resp))
	})

	http.ListenAndServe(":8086", nil)
}
