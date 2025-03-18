#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <list>
#include "Song.h"

class Playlist {
public:
    void enqueue(const std::string& title, const 
std::string& artist, int duration);
    Song* dequeue();
    void removeSong(const std::string& title);
    int getNumberOfSongs() const;
    int getTotalDuration() const;
    void shuffle();
    void play() const;

private:
    struct Node {
        Song song_;
        Node* next_;
        Node* prev_;
    };

    void addNodeAtHead(Node* node);
    Node* removeNodeFromTail();

    std::list<Node*> nodes_;  // Doubly linked list
};

#endif  // PLAYLIST_H
