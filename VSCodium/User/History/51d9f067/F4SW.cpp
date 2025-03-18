#include<iostream>
#include "Playlist.h"

// Example usage and testing
int main() {
    Playlist playlist;

    std::cout << "Testing Operations:\n";
    std::cout << "-------------------------\n";

    // Add some sample songs
    playlist.enqueue("Bohemian Rhapsody", "Queen", 354);
    playlist.enqueue("Stairway to Heaven", "Led Zeppelin", 482);
    playlist.enqueue("Sweet Child O' Mine", "Guns N' Roses", 356);
    playlist.enqueue("Hotel California", "Eagles", 391);
    playlist.enqueue("Imagine", "John Lennon", 183);

    // Display initial playlist
    std::cout << "Initial playlist:\n";
    playlist.play();

    // First test of size and duration
    std::cout << "\nNumber of songs: " << playlist.getNumberOfSongs() << "\n";
    std::cout << "Playlist duration: " << playlist.getTotalDuration() << "\n";

    // Remove a song
    playlist.removeSong("Hotel California");
    std::cout << "\nAfter removing 'Hotel California':\n";
    playlist.play();

    // Shuffle playlist
    playlist.shuffle();
    std::cout << "\nAfter shuffling:\n";
    playlist.play();

    // Test explicit dequeue operation
    std::cout << "\nTesting dequeue operation:\n";
    Song* dequeuedSong = playlist.dequeue();
    if (dequeuedSong) {
        std::cout << "Dequeued song: " << dequeuedSong->getTitle() << " - "
                 << dequeuedSong->getArtist() << "\n";
        delete dequeuedSong;  // Don't forget to clean up!
    }

    // Printing the whole playlist again
    std::cout << "\nPlaylist after dequeue:\n";
    playlist.play();

    // Last test of size and duration
    std::cout << "\nNumber of songs: " << playlist.getNumberOfSongs() << "\n";
    std::cout << "Playlist duration: " << playlist.getTotalDuration() << "\n";

    return 0;
}