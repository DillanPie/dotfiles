#include "Song.hpp"

// Constructor implementation for the Song class
// Initializes a new song with the provided title, artist, and duration
Song::Song(const std::string& title, const std::string& artist, int duration)
    : title(title), artist(artist), duration(duration) {}

// Getter implementation for the Song class
// Returns the title of the song
std::string Song::getTitle() const {
    return title;
}
// Returns the title of the Artist
std::string Song::getArtist() const {
    return artist;
}
//Returns the duration of the song in seconds
int Song::getDuration() const {
    return duration;
}

// Setter implementation for the Song class
// Sets a new title for the song
void Song::setTitle(const std::string& newTitle) {
    title = newTitle;
}

// Sets a new artist for the song
void Song::setArtist(const std::string& newArtist) {
    artist = newArtist;
}

// Sets a new duration for the song (in seconds)
void Song::setDuration(int newDuration) {
    duration = newDuration;
}
