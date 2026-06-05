package main

import (
	"fmt"
	// "io"
	// "html/template"
	"log"
	"net/http"
)

func indexHandler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "./basic_site/index.html")

}

func main() {
	fmt.Println("Go Main")
	http.HandleFunc("/", indexHandler)
	http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("./basic_site/static/"))))
	//
	log.Println("server starting 9000")
	log.Fatal(http.ListenAndServe(":9000", nil))
}
