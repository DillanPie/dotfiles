#ifndef PLAYLIST_H
#define PLAYLIST_H

#include "Node.hpp"
#include <iostream>
#include <cstdlib>
#include <ctime>

// Represents a playlist of songs, with methods to add, remove, and play songs
class Playlist {
private:
    Node* head;// Pointer to the first node in the playlist (head)
    Node* tail;// Pointer to the last node in the playlist (tail)
    int songCount;//Number of songs in the playlist
    int totalDuration;//Total duration of the songs within the playlists

public:
    // Constructor to initialize an empty playlist
    Playlist();
    // Destructor to free memory allocated for the playlist
    ~Playlist();

    void enqueue(const std::string& title, const std::string& artist, int duration);
    void removeSong(const std::string& title);
    Song* dequeue();
    void play() const;
    void shuffle();
    
    int getNumberOfSongs() const;
    int getTotalDuration() const;
};

#endif
