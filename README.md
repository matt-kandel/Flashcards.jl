### Basic Flashcard app
Created in Julia 1.9

Everything runs in the command line. There's no fancy Spaced Repetition algorithm or anything. You select which decks you want to include. After each card, if you get it right, it will be removed from the deck. If you get it wrong, it will be put at the bottom of the deck, and you won't see it until you've seen all the other cards at least once.

The decks are study materials for Exam 6. If you want to add new cards or decks, the format is:

Question
* Answer 1
* Answer 2
* Answer 3

Where any lines that begin with * will be parsed as part of the answer.