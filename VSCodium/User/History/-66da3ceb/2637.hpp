#ifndef NODE_H
#define NODE_H

#include "Song.hpp"

struct Node {
    Song song;
    Node* next;
    Node* prev;

    Node(const Song& song) : song(song), next(nullptr), prev(nullptr) {}
};

#endif
