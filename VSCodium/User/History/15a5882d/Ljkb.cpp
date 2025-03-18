#include <iostream>
#include "Playlist.hpp"

int main() {
    Playlist playlist;

    std::cout << "========== Playlist Functionality Test ==========\n";

    // 1. Test adding songs
    std::cout << "\nAdding songs to the playlist...\n";
    playlist.enqueue("Bohemian Rhapsody", "Queen", 354);
    playlist.enqueue("Stairway to Heaven", "Led Zeppelin", 482);
    playlist.enqueue("Sweet Child O' Mine", "Guns N' Roses", 356);
    playlist.enqueue("Hotel California", "Eagles", 391);
    playlist.enqueue("Imagine", "John Lennon", 183);
    playlist.enqueue("Smells Like Teen Spirit", "Nirvana", 278);
    playlist.enqueue("Wonderwall", "Oasis", 259);

    // Print initial playlist
    std::cout << "\nCurrent Playlist:\n";
    playlist.play();

    // 2. Test size and duration
    std::cout << "\nTotal Songs: " << playlist.getNumberOfSongs() << "\n";
    std::cout << "Total Duration: " << playlist.getTotalDuration() << " seconds\n";

    // 3. Test removing a song that exists
    std::cout << "\nRemoving 'Hotel California'...\n";
    playlist.removeSong("Hotel California");
    playlist.play();

    // 4. Test removing a song that doesn't exist
    std::cout << "\nAttempting to remove a non-existent song ('Yellow Submarine')...\n";
    playlist.removeSong("Yellow Submarine");
    playlist.play();

    // 5. Test shuffling multiple times to ensure randomness
    std::cout << "\nShuffling playlist...\n";
    playlist.shuffle();
    playlist.play();

    std::cout << "\nShuffling again...\n";
    playlist.shuffle();
    playlist.play();

    // 6. Test dequeuing
    std::cout << "\nTesting Dequeue (Removing Last Song)...\n";
    Song* dequeuedSong = playlist.dequeue();
    if (dequeuedSong) {
        std::cout << "Dequeued song: " << dequeuedSong->getTitle() << " - " << dequeuedSong->getArtist() << "\n";
        delete dequeuedSong; // Clean up if dynamically allocated
    }

    // 7. Test dequeuing multiple times until empty
    // std::cout << "\nDequeue all songs until the playlist is empty...\n";
    // while (!playlist.isEmpty()) {
    //     Song* removedSong = playlist.dequeue();
    //     if (removedSong) {
    //         std::cout << "Removed: " << removedSong->getTitle() << " - " << removedSong->getArtist() << "\n";
    //         delete removedSong;
    //     }
    // }

    // 8. Verify playlist is empty
    std::cout << "\nFinal check - Playlist should be empty:\n";
    playlist.play();
    std::cout << "Total Songs: " << playlist.getNumberOfSongs() << "\n";
    std::cout << "Total Duration: " << playlist.getTotalDuration() << " seconds\n";

    // 9. Test edge case: Removing from an empty playlist
    std::cout << "\nAttempting to remove a song from an empty playlist...\n";
    playlist.removeSong("Imagine");

    // 10. Test edge case: Dequeue from an empty playlist
    std::cout << "\nAttempting to dequeue from an empty playlist...\n";
    Song* emptyDequeue = playlist.dequeue();
    if (!emptyDequeue) {
        std::cout << "Dequeue failed - Playlist is already empty.\n";
    }

    std::cout << "\n========== End of Testing ==========\n";

    return 0;
}
