package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	port := 8080

	r := mux.NewRouter()
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Go Server")
	})

	log.Printf("App listening on port %d!", port)

	url := fmt.Sprintf(":%d", port)
	http.ListenAndServe(url, r)
}
