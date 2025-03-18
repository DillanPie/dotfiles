#include "Song.hpp"

// Constructor
Song::Song(const std::string& title, const std::string& artist, int duration)
    : title(title), artist(artist), duration(duration) {}

// Getters
std::string Song::getTitle() const {
    return title;
}

std::string Song::getArtist() const {
    return artist;
}

int Song::getDuration() const {
    return duration;
}

// Setters (Fixed)
void Song::setTitle(const std::string& newTitle) {
    title = newTitle;
}

void Song::setArtist(const std::string& newArtist) {
    artist = newArtist;
}

void Song::setDuration(int newDuration) {
    duration = newDuration;
}
