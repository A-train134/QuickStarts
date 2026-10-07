package main

import (
	"context"
	"flag"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

var PROJECT_NAME = "test_site"
var DIR_NAME = PROJECT_NAME
var INDEX_HTML = "index.html"
var INDEX_CSS = "index.css"
var INDEX_JS = "index.js"
var STATIC = "static"
var IMAGES = "images"

type Thing struct {
	Name  string
	Path  string
	IsDir bool
	Data  string
}

var project = Thing{Name: PROJECT_NAME, Path: PROJECT_NAME, IsDir: true, Data: ""}
var index = Thing{Name: INDEX_HTML, Path: PROJECT_NAME + "/" + INDEX_HTML, IsDir: false, Data: INDEX_DATA}
var static = Thing{Name: IMAGES, Path: PROJECT_NAME + "/" + STATIC, IsDir: true, Data: ""}
var css = Thing{Name: INDEX_CSS, Path: PROJECT_NAME + "/" + STATIC + "/" + INDEX_CSS, IsDir: false, Data: INDEX_CSS_DATA}
var js = Thing{Name: INDEX_CSS, Path: PROJECT_NAME + "/" + STATIC + "/" + INDEX_JS, IsDir: false, Data: INDEX_JS_DATA}
var images = Thing{Name: IMAGES, Path: PROJECT_NAME + "/" + STATIC + "/" + IMAGES, IsDir: true, Data: ""}
var things = []Thing{project, static, images, index, css, js}

func setup() {
	for i := range len(things) {
		info, err := os.Stat(things[i].Name)
		if err != nil {
			log.Println(err)
			if things[i].IsDir {
				log.Println("Create ", things[i].Name)
				os.Mkdir(things[i].Path, 0755)
			} else if !(things[i].IsDir) {
				log.Println("Create ", things[i].Name)
				file, err := os.Create(things[i].Path)
				if err != nil {
					panic(err)
				} else {
					log.Println(file.Name())
				}
				defer file.Close()
				n, err := file.WriteString(things[i].Data)
				if err != nil {
					log.Println("index write error")
					panic(err)
				} else {
					log.Println("wrote index ", n)
				}

			} else {
				log.Println(info.Name(), " Exists")
			}
		}
	}
}

var META_HTML = template.HTML(fmt.Sprintf(`<meta name="viewport" content="width=device-width initial-scale=1.0">`))
var FAVICON_HTML = template.HTML(fmt.Sprintf(`<link rel="icon" href="%s/%s/favicon.ico" type="image/x-icon">`, STATIC, IMAGES))

type HEAD_HTML struct {
	Meta    template.HTML
	Favicon template.HTML
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	templ := template.Must(template.ParseFiles("./" + PROJECT_NAME + "/" + INDEX_HTML))
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return

	}
	head := HEAD_HTML{Meta: META_HTML, Favicon: FAVICON_HTML}
	err := templ.Execute(w, struct{ T HEAD_HTML }{head})
	if err != nil {
		log.Println(err)
	}
}
func handlers() {
	//

}

// folder -> index.html, static -> index.js, index.css
func main() {
	log.Println("Hello")
	//
	srv := http.Server{Addr: ":9000", Handler: nil}
	srv_running := false
	setup_flag := flag.Bool("setup", false, "Runs Dir and file setup")
	server_flag := flag.Bool("server", false, "Runs the server")
	delete_flag := flag.Bool("delete", false, "deletes the dir and files")
	flag.Parse()
	//
	if *setup_flag {
		// setup()
		setup()
	}
	if *server_flag {
		http.HandleFunc("/", indexHandler)
		http.Handle("/"+STATIC+"/", http.StripPrefix("/"+STATIC+"/", http.FileServer(http.Dir("./"+PROJECT_NAME+"/"+STATIC))))
		log.Println("Server Starting 9000")
		go func() {
			err := srv.ListenAndServe()
			if err != nil && err != http.ErrServerClosed {
				log.Fatalln("listen and serve fail")
			}
		}()
		srv_running = true
	}
	if srv_running {
		sig := make(chan os.Signal, 1)
		signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
		<-sig
		//
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()
		//
		err := srv.Shutdown(ctx)
		if err != nil {
			log.Fatal(err)
		}
		log.Println("Shutdown Server")
	}
	if *delete_flag {
		log.Println("Delete Project")
		os.RemoveAll("./" + PROJECT_NAME)
	}
	//
}

// do templates
var INDEX_DATA = fmt.Sprintf(`
<!DOCTYPE html>
<html>

<head>
    {{.T.Meta}}
    {{.T.Favicon}}
    <link rel="stylesheet" href="/%s/%s">
    <script src="%s/%s"></script>
</head>

<body>
    <div>The Center</div>
    <div>Basic Go Website</div>
</body>

</html>
`, STATIC, "index.css", STATIC, "index.js")

var INDEX_JS_DATA = `
document.addEventListener("DOMContentLoaded", () => {
    console.log("DOMContentLoaded")
})
`
var INDEX_CSS_DATA = `
html body{
	height: 100vh;
	margin: 0;
	overflow: hidden;

}
body {
	display: flex;
	justify-content: center;
	align-items: center;
	flex-direction: column;
	background-color: rgb(20,20,20);
	color: white;
	text-shadow: 0 0 3px black;

}
`
