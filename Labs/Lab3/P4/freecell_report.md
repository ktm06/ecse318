Each of the 52 cards were represented with a 6-bit vector where the two most significant bits encoded the suit of the card and the four least significant bits represented the value of the card The 6-bit encoding minimizes resource usage while clearly distinguishing all 52 cards and eparating suit and value simplifies move validation logic.
The tableau columns were represented as a 7 x 8 2d array with each index containing a 6 bit card. An array register was used to tracks the number of cards in each column (allowing columns to grow or shrink as cards are moved).
The freecells were represented as an array for the four free cells with each index containing a 6 bit card. An bitmask was used to track which freecells were occupied.
The homecells were represented as an a 13 x 4 2d array with each index containing a 6 bit card. An array register was used to track the number of cards in each homecell.
The win signal is updated and transitions to 1 when all 52 cards are in their homecells.
The design enforces the FreeCell rules and accounts for edge cases such as: Moving a card to an empty tableau column is always valid, Only Aces can be moved to empty homecells. Attempting to move a card to a full freecell is rejected, Moves that violate FreeCell rules are ignored, and the state remains unchanged.
The design uses the following registers, which correspond to 717 Total latches in a synthesized design:
Tableau ->	8 columns × 7 cards × 6 bits = 336 latches
Column Count ->	8 columns × 3 bits = 24 latches
Freecells -> 4 freecells × 6 bits = 24 latches
Freecell Card Bitmask -> 4 bits = 4 latches
Homecells -> 4 suits × 13 cards × 6 bits = 312 latches
Home Count -> 4 suits × 4 bits = 16 latches
Win Signal	-> 1 bit = 1 latches
