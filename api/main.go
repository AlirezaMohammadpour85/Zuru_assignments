package main

import (
	"fmt"
	"log"
	"net/http"
)

func healthHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Received request on /health")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "Working!!! The server responded with a status of 200 (OK)")
}

func main() {
	http.HandleFunc("/health", healthHandler)

	port := "8080"
	log.Printf("Starting server on port %s...\n", port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal("Server failed:", err)
	}
}
