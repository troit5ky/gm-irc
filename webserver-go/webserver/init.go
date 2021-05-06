package webserver

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"webserver-go/bot"
)

type (
	MsgStruct struct {
		Author    string `json:"author"`
		Content   string `json:"content"`
		Timestamp int    `json:"timestamp"`
		IsBot     bool   `json:"isbot"`
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
			tsparse, _ := msg.Timestamp.Parse()
			ts := int(tsparse.Unix())
			MsgArr[i] = MsgStruct{Author: msg.Author.Username, Content: msg.Content, Timestamp: ts, IsBot: msg.Author.Bot}
		}

		Resp, err := json.Marshal(MsgArr)
		if err != nil {
			log.Println(err)
		}

		fmt.Fprintf(w, string(Resp))
	})

	http.ListenAndServe(":8086", nil)
}
