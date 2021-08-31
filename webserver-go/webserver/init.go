package webserver

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

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

func Init() {
	defer log.Println("Webserver started!")

	http.HandleFunc("/getmsghistory", func(w http.ResponseWriter, r *http.Request) {
		var MsgArr []MsgStruct
		limit, err := strconv.Atoi(r.URL.Query().Get("limit"))

		if err != nil {
			limit = 10
		}

		MsgRawArr := bot.GetMsgHistory(limit)
		for _, msg := range MsgRawArr {
			tsparse, _ := msg.Timestamp.Parse()
			ts := int(tsparse.Unix())

			replacer := strings.NewReplacer("%", "", "\\", "")
			msg.Content = replacer.Replace(msg.Content)

			if msg.Content == "" {
				msg.Content = "(вложение)"
			}

			data := MsgStruct{Author: msg.Author.Username, Content: msg.Content, Timestamp: ts, IsBot: msg.Author.Bot}
			MsgArr = append(MsgArr, data)
		}

		Resp, err := json.Marshal(MsgArr)
		if err != nil {
			log.Println(err)
		}

		w.Header().Add("Content-Type", "application/json")
		fmt.Fprintf(w, string(Resp))
	})

	http.ListenAndServe(":8086", nil)
}
