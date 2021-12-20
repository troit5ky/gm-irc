package webserver

import (
	"log"
	"net/http"
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

	http.HandleFunc("/getmsghistory", GetMsgHistory)

	http.ListenAndServe(":8086", nil)
}
