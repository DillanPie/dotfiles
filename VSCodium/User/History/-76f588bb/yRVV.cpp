// Chat Client Program
// This program connects to a chat server, allows users to join rooms, set nicknames, and chat.
// Honor Pledge: I have neither given nor received any unauthorized aid on this assignment.

#include <iostream>
#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/select.h>

#define SERVER_IP "104.197.153.180"
#define SERVER_PORT 41400
#define BUFFER_SIZE 1024

void handleServerMessages(int clientSocket) {
    char buffer[BUFFER_SIZE];
    int bytesRead = recv(clientSocket, buffer, sizeof(buffer) - 1, 0);
    if (bytesRead > 0) {
        buffer[bytesRead] = '\0';
        std::cout << "Server: " << buffer << std::endl;
    } else {
        std::cerr << "Disconnected from server." << std::endl;
        close(clientSocket);
        exit(0);
    }
}

int main() {
    int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSocket < 0) {
        std::cerr << "Failed to create socket." << std::endl;
        return 1;
    }

    sockaddr_in serverAddress;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_port = htons(SERVER_PORT);
    inet_pton(AF_INET, SERVER_IP, &serverAddress.sin_addr);

    if (connect(clientSocket, (struct sockaddr*)&serverAddress, sizeof(serverAddress)) < 0) {
        std::cerr << "Failed to connect to server." << std::endl;
        return 1;
    }

    std::cout << "Connected to chat server." << std::endl;

    fd_set read_fds;
    char buffer[BUFFER_SIZE];

    while (true) {
        FD_ZERO(&read_fds);
        FD_SET(clientSocket, &read_fds);
        FD_SET(STDIN_FILENO, &read_fds);

        if (select(clientSocket + 1, &read_fds, nullptr, nullptr, nullptr) < 0) {
            std::cerr << "Error in select." << std::endl;
            break;
        }

        if (FD_ISSET(clientSocket, &read_fds)) {
            handleServerMessages(clientSocket);
        }

        if (FD_ISSET(STDIN_FILENO, &read_fds)) {
            std::cin.getline(buffer, BUFFER_SIZE);
            if (std::string(buffer) == "/logout") {
                send(clientSocket, buffer, strlen(buffer), 0);
                std::cout << "Logging out..." << std::endl;
                break;
            }
            send(clientSocket, buffer, strlen(buffer), 0);
        }
    }

    close(clientSocket);
    return 0;
}
