// Chat Client Program
// Purpose: Connects to a chat server, allows users to join rooms, set a nickname, and chat.
// Honor Pledge: I hereby declare upon my word of honor that I have neither given nor received unauthorized help on this work.

#include <iostream>
#include <cstring>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/select.h>

#define SERVER_IP "104.197.153.180"
#define SERVER_PORT 41400
#define BUFFER_SIZE 1024

void sendMessage(int socket, const std::string& message) {
    send(socket, message.c_str(), message.length(), 0);
}

std::string receiveMessage(int socket) {
    char buffer[BUFFER_SIZE] = {0};
    int bytesReceived = recv(socket, buffer, BUFFER_SIZE - 1, 0);
    return (bytesReceived > 0) ? std::string(buffer) : "";
}

int main() {
    // Creating socket
    int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSocket == -1) {
        std::cerr << "Error creating socket.\n";
        return 1;
    }

    // Configuring server address
    sockaddr_in serverAddress;
    serverAddress.sin_family = AF_INET;
    serverAddress.sin_port = htons(SERVER_PORT);
    inet_pton(AF_INET, SERVER_IP, &serverAddress.sin_addr);

    // Connecting to the server
    if (connect(clientSocket, (struct sockaddr*)&serverAddress, sizeof(serverAddress)) == -1) {
        std::cerr << "Connection failed.\n";
        return 1;
    }

    std::cout << "Connected to chat server!\n";

    // Main interaction loop
    std::string userInput;
    while (true) {
        std::cout << "Enter '/list' to view rooms or '/join ROOM' to join a room: ";
        std::getline(std::cin, userInput);

        sendMessage(clientSocket, userInput);
        std::string response = receiveMessage(clientSocket);

        if (userInput == "/list") {
            int numRooms = std::stoi(response);
            std::cout << "Number of rooms: " << numRooms << "\n";
            for (int i = 0; i < numRooms; i++) {
                std::cout << receiveMessage(clientSocket) << "\n";
            }
        } else if (userInput.rfind("/join ", 0) == 0) {
            if (response == "0") {
                std::cout << "Successfully joined room.\n";
                break;
            } else {
                std::cout << "Failed to join room. Try again.\n";
            }
        }
    }

    // Setting nickname
    while (true) {
        std::cout << "Enter your nickname: ";
        std::getline(std::cin, userInput);
        sendMessage(clientSocket, "/nick " + userInput);
        std::string response = receiveMessage(clientSocket);

        if (response == "0") {
            std::cout << "Nickname set successfully!\n";
            break;
        } else if (response == "2") {
            std::cout << "Nickname taken, try another.\n";
        } else {
            std::cout << "Invalid nickname, try again.\n";
        }
    }

    // Enable non-blocking mode for select
    fcntl(clientSocket, F_SETFL, O_NONBLOCK);

    fd_set readfds;
    while (true) {
        FD_ZERO(&readfds);
        FD_SET(clientSocket, &readfds);
        FD_SET(STDIN_FILENO, &readfds);

        select(clientSocket + 1, &readfds, nullptr, nullptr, nullptr);

        if (FD_ISSET(clientSocket, &readfds)) {
            std::string serverMessage = receiveMessage(clientSocket);
            if (!serverMessage.empty()) {
                std::cout << serverMessage << "\n";
            }
        }

        if (FD_ISSET(STDIN_FILENO, &readfds)) {
            std::getline(std::cin, userInput);
            if (userInput == "/logout") {
                sendMessage(clientSocket, userInput);
                break;
            }
            sendMessage(clientSocket, userInput);
        }
    }

    std::cout << "Disconnecting...\n";
    close(clientSocket);
    return 0;
}
