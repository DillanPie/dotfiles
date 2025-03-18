#include "Playlist.h"

// Constructor
Playlist::Playlist() : head(nullptr), tail(nullptr), songCount(0), totalDuration(0) {}

// Destructor
Playlist::~Playlist() {
    Node* current = head;
    while (current) {
        Node* next = current->next;
        delete current;
        current = next;
    }
}

// Enqueue (Add song to end)
void Playlist::enqueue(const std::string& title, const std::string& artist, int duration) {
    Song newSong(title, artist, duration);
    Node* newNode = new Node(newSong);

    if (!tail) {  // Empty list
        head = tail = newNode;
    } else {
        tail->next = newNode;
        newNode->prev = tail;
        tail = newNode;
    }
    songCount++;
    totalDuration += duration;
}

// Dequeue (Remove song from end)
Song* Playlist::dequeue() {
    if (!tail) return nullptr;

    Node* temp = tail;
    Song* song = new Song(temp->song); // Return a copy of the song

    if (head == tail) {  // Only one element
        head = tail = nullptr;
    } else {
        tail = tail->prev;
        tail->next = nullptr;
    }

    delete temp;
    songCount--;
    totalDuration -= song->getDuration();
    return song;
}

// Remove song by title
void Playlist::removeSong(const std::string& title) {
    Node* current = head;
    
    while (current) {
        if (current->song.getTitle() == title) {
            if (current == head) head = current->next;
            if (current == tail) tail = current->prev;
            if (current->prev) current->prev->next = current->next;
            if (current->next) current->next->prev = current->prev;

            totalDuration -= current->song.getDuration();
            delete current;
            songCount--;
            return;
        }
        current = current->next;
    }
}

// Play playlist (Print all songs)
void Playlist::play() const {
    Node* current = head;
    while (current) {
        std::cout << current->song.getTitle() << " - " 
                  << current->song.getArtist() << " (" 
                  << current->song.getDuration() << "s)\n";
        current = current->next;
    }
}

// Get number of songs
int Playlist::getNumberOfSongs() const {
    return songCount;
}

// Get total duration
int Playlist::getTotalDuration() const {
    return totalDuration;
}

// Shuffle the playlist manually (Fisher-Yates Shuffle)
void Playlist::shuffle() {
    if (!head || !head->next) return;

    std::srand(std::time(0));  // Seed random number generator
    int n = songCount;

    for (int i = 0; i < n - 1; ++i) {
        int j = i + std::rand() % (n - i);  // Random index

        // Find ith and jth nodes
        Node* first = head;
        for (int k = 0; k < i; ++k) first = first->next;
        
        Node* second = head;
        for (int k = 0; k < j; ++k) second = second->next;

        // Swap song data (not nodes, just the song object)
        std::swap(first->song, second->song);
    }
}
