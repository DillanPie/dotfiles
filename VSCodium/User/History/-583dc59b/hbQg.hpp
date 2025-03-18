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

    // Adds a new song to the end of the playlist
    void enqueue(const std::string& title, const std::string& artist, int duration);

    // Removes a song from the playlist by its title
    void removeSong(const std::string& title);

    // Removes and returns the last song added to the playlist
    Song* dequeue();

    // Plays the entire playlist (prints out each song's data)
    void play() const;

    // Shuffles the order of songs in the playlist using Fisher-Yates Shuffle algorithm
    void shuffle();
    
    int getNumberOfSongs() const;
    int getTotalDuration() const;
};

#endif
