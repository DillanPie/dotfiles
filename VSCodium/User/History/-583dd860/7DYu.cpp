#include "Playlist.h"
#include <cstdlib>
#include <ctime>

void Playlist::enqueue(const std::string& title, const 
std::string& artist, int duration) {
    Node* newNode = new Node();
    newNode->song_.setTitle(title);
    newNode->song_.setArtist(artist);
    newNode->song_.setDuration(duration);

    newNode->next_ = nodes_.front();
    if (!nodes_.empty()) {
        newNode->prev_ = &nodes_[0];
        newNode->prev_->next_ = newNode;
    } else {
        newNode->prev_ = nullptr;
    }

    nodes_.push_front(newNode);
}

Song* Playlist::dequeue() {
    if (isEmpty()) {
        return nullptr;
    }
    Node* node = removeNodeFromTail();
    return &node->song_;
}

void Playlist::removeSong(const std::string& title) {
    for (auto it = nodes_.begin(); it != nodes_.end();) {
        if ((*it)->song_.getTitle() == title) {
            if (it == nodes_.front()) {
                delete *it;
                it = nodes_.begin();
            } else {
                Node* nextNode = (*it)->next_;
                (*it)->prev_->next_ = nextNode;
                if (nextNode->prev_) {
                    nextNode->prev_->prev_ = 
(*it)->prev_;
                }
                delete *it;
                it = nodes_.erase(it);
            }
            break;
        }
        ++it;
    }
}

int Playlist::getNumberOfSongs() const {
    return static_cast<int>(nodes_.size());
}

int Playlist::getTotalDuration() const {
    int duration = 0;
    for (auto it = nodes_.begin(); it != nodes_.end();) {
        duration += (*it)->song_.getDuration();
        ++it;
    }
    return duration;
}

void Playlist::shuffle() {
    if (isEmpty()) {
        return;
    }

    std::srand(std::time(0));  // Seed random number 
generator
    for (auto it = nodes_.begin(); it != nodes_.end();) {
        Node* newNode = nodes_.randit() + 
static_cast<int>(std::rand() % nodes_.size());
        nodes_[it]->next_ = *newNode;
        (*newNode)->prev_ = nodes_[it];
        if (it == nodes_.front()) {
            nodes_[0] = *it;
        }
        (*it) = newNode;
        ++it;
    }
}

void Playlist::play() const {
    for (auto it = nodes_.begin(); it != nodes_.end;) {
        std::cout << (*it)->song_.getTitle() << " - "
                  << (*it)->song_.getArtist()
                  << "(" << (*it)->song_.getDuration() << 
")" << std::endl;
        ++it;
    }
}

void Playlist::addNodeAtHead(Node* node) {
    if (!nodes_.empty()) {
        Node* newNode = new Node();
        newNode->next_ = nodes_[0];
        if (nodes_[0]) {
            nodes_[0]->prev_ = newNode;
        } else {
            nodes_.push_front(newNode);
        }
        nodes_.insert(nodes_.begin(), node);
    } else {
        nodes_.push_back(node);
    }
}
