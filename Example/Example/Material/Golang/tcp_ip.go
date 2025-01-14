package main

import (
	"fmt"
	"net"
)

func main() {
    
	// 監聽 TCP Port
	listener, err := net.Listen("tcp", ":8080")
    
	if err != nil {
		fmt.Println("Error listening:", err)
		return
	}
    
	defer listener.Close()

	fmt.Println("Server listening on :8080")

	// 持續接受連線
	for {
        
		conn, err := listener.Accept()
        
		if err != nil {
			fmt.Println("Error accepting connection:", err)
			continue
		}

		// 處理每個連線
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {

	defer conn.Close()

	buffer := make([]byte, 1024)

	for {
        
		nunber, err := conn.Read(buffer)
		if err != nil {
			return
		}
        
		bytes := buffer[:nunber]
		println(string(bytes))

		// echo 收到的資料
		conn.Write(bytes)
	}
}
