#include "Song.hpp"

std::string Song::getTitle() const {
    return title;
}

void Song::setTitle(const std::string& title) {
    title = title;
}

std::string Song::getArtist() const {
    return artist;
}

void Song::setArtist(const std::string& artist) {
    artist = artist;
}

int Song::getDuration() const {
    return duration;
}