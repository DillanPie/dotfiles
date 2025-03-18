#ifndef NODE_H
#define NODE_H

#include "Song.hpp"

// Represents a node in the playlist, containing a song and references to previous and next nodes
struct Node {
    Song song;// Song data stored in this node
    Node* next;// Pointer to the next node in the playlist
    Node* prev;// Pointer to the previous node in the playlist

    // Constructor to initialize a new node with a given song
    Node(const Song& song) : song(song), next(nullptr), prev(nullptr) {}
};

#endif
