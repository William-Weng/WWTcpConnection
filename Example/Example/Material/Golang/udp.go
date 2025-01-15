package main

import (
	"fmt"
	"net"
)

func main() {

	addr := net.UDPAddr{
		Port: 8080,
		IP:   net.ParseIP("127.0.0.1"),
	}

	conn, err := net.ListenUDP("udp", &addr)
	if err != nil {
		fmt.Printf("Listen error: %v\n", err)
		return
	}
	defer conn.Close()

	buffer := make([]byte, 1024)

	for {
		number, remoteAddr, err := conn.ReadFromUDP(buffer)
		if err != nil {
			fmt.Printf("Read error: %v\n", err)
			continue
		}

		fmt.Printf("Received %d bytes from %v: %s\n", number, remoteAddr, string(buffer[:number]))

		// 回覆訊息
		_, err = conn.WriteToUDP(buffer[:number], remoteAddr)
		if err != nil {
			fmt.Printf("Write error: %v\n", err)
		}
	}
}
