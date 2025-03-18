#ifndef SONG_H
#define SONG_H

#include <string>

class Song {
public:
    std::string getTitle();
    void setTitle(const std::string& title);
    std::string getArtist();
    void setArtist(const std::string& artist);
    int getDuration();

private:
    std::string title_;
    std::string artist_;
    int duration_;
};

#endif  // SONG_H
