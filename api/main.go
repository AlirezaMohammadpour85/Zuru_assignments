// main.go - A simple HTTP server using the net/http package (no external dependencies).
//
// This application listens on port 8080 and provides two endpoints:
//
//  1. GET / - The root endpoint that returns a message prompting the user to
//     use the /health endpoint.
//
//  2. GET /health - This endpoint returns a status message indicating that the
//     server is operational and responding with a status of 200 (OK).
//
// The server logs incoming requests to the console for monitoring purposes.

package main

import (
	"fmt"
	"log"
	"net/http"
)

// / Root handler function
func homeHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Received request on root /")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "This is root folder- Please use /health for the assignement !")
}

// /Health handler function
func healthHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Received request on /health")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "Working!!! The server responded with a status of 200 (OK)")
}

func main() {
	// Define routes - start
	http.HandleFunc("/", homeHandler)
	http.HandleFunc("/health", healthHandler)
	// Define routes - end

	// Start the server - start
	port := "8080"
	log.Printf("Starting server on port %s...\n", port)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatal("Server failed:", err)
	}
	// Start the server - end
}
