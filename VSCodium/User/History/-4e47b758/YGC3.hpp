#ifndef SONG_H
#define SONG_H

#include <string>

class Song {
private:
    std::string title;
    std::string artist;
    int duration;

public:
    Song(const std::string& title, const std::string& artist, int duration);
    
    std::string getTitle() const;
    std::string getArtist() const;
    int getDuration() const;

    void setTitle(const std::string& title);
    void setArtist(const std::string& artist);
    void setDuration(int duration);
};

#endif
