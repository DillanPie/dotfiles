#ifndef PLAYLIST_H
#define PLAYLIST_H

#include "Node.h"
#include <iostream>
#include <cstdlib>
#include <ctime>

class Playlist {
private:
    Node* head;
    Node* tail;
    int songCount;
    int totalDuration;

public:
    Playlist();
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
