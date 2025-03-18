#ifndef SONG_H
#define SONG_H

#include <string>

// Represents a song in the playlist
class Song {
private:
    std::string title;// Title of the song
    std::string artist;//Artist of the song
    int duration;//Playtime of the song

public:
    // Constructor to initialize a new song
    Song(const std::string& title, const std::string& artist, int duration);
    
    std::string getTitle() const;// Getter for song title
    std::string getArtist() const;// Getter for song artist
    int getDuration() const;// Getter for playtime of the song

    void setTitle(const std::string& title);//Setter for the song title
    void setArtist(const std::string& artist);// Setter for the song title
    void setDuration(int duration);// Setter for the song title
};

#endif
