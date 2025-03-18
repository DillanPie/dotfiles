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

#define SERVER_IP "104.197.153.180" // Sever ip to connect
#define SERVER_PORT 41400 // Sever port number
#define BUFFER_SIZE 1024 // Server Buffer size

 // Send Messages Function
void sendMessage(int socket, const std::string& message) {
    send(socket, message.c_str(), message.length(), 0);
}

 // Receive Messages Function
std::string receiveMessage(int socket) {
    char buffer[BUFFER_SIZE] = {0}; // Buffer to store received data
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
    serverAddress.sin_port = htons(SERVER_PORT); // convert port to network byte order
    inet_pton(AF_INET, SERVER_IP, &serverAddress.sin_addr); // convert IP to binary format

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

        sendMessage(clientSocket, userInput); // send user input to the server
        std::string response = receiveMessage(clientSocket); // get response from server

        if (userInput == "/list") { // If user requests a list of rooms, receive the number of rooms
            int numRooms = std::stoi(response);
            std::cout << "Number of rooms: " << numRooms << "\n";
            for (int i = 0; i < numRooms; i++) {
                std::cout << receiveMessage(clientSocket) << "\n";
            }
        // recive and display each room name
        } else if (userInput.rfind("/join ", 0) == 0) {
            if (response == "0") {
                std::cout << "Successfully joined room.\n";
                break;// exit loop after successfully joining a room
            } else {
                std::cout << "Failed to join room. Try again.\n";
            }
        }
    }

    // Loop for  Setting nickname
    while (true) {
        std::cout << "Enter your nickname: ";
        std::getline(std::cin, userInput);
        sendMessage(clientSocket, "/nick " + userInput);
        std::string response = receiveMessage(clientSocket);

        // Check server for nickname validation
        if (response == "0") {
            std::cout << "Nickname set successfully!\n";
            break; // exit loop after nickname is set
        } else if (response == "2") {
            std::cout << "Nickname taken, try another.\n";
        } else {
            std::cout << "Invalid nickname, try again.\n";
        }
    }

    // Enable non-blocking mode for select
    fcntl(clientSocket, F_SETFL, O_NONBLOCK);

    fd_set readfds; // File descriptor set for `select()`
    while (true) {
        FD_ZERO(&readfds); // Clear the file descriptor
        FD_SET(clientSocket, &readfds); //Add socket to set
        FD_SET(STDIN_FILENO, &readfds); //Add stanard input 

        // Wait until there is data available to read
        select(clientSocket + 1, &readfds, nullptr, nullptr, nullptr);

        // Check if the server has sent a message
        if (FD_ISSET(clientSocket, &readfds)) {
            std::string serverMessage = receiveMessage(clientSocket);
            if (!serverMessage.empty()) {
                std::cout << serverMessage << "\n";
            }
        }

        // Check if user has sent a message
        if (FD_ISSET(STDIN_FILENO, &readfds)) {
            std::getline(std::cin, userInput);
            if (userInput == "/logout") { // checks if user wishes to logout
                sendMessage(clientSocket, userInput);
                break; //exits loop to disconnect from the server.
            }
            sendMessage(clientSocket, userInput);
        }
    }

    // Close the connection and exit
    std::cout << "Disconnecting...\n";
    close(clientSocket);
    return 0;
}
