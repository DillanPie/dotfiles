#include "Song.hpp"

std::string Song::getTitle() const {
    return title_;
}

void Song::setTitle(const std::string& title) {
    title_ = title;
}

std::string Song::getArtist() const {
    return artist_;
}

void Song::setArtist(const std::string& artist) {
    artist_ = artist;
}

int Song::getDuration() const {
    return duration_;
}