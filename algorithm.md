* Is the latest tetromino placement valid?
    * YES: Find the next available tetromino and place it.
    * NO: Remove it. Is there another rotation available?
        * YES: Place that rotation
        * NO: Is there another tetromino available?
            * YES: Place that tetromino in its first rotation.
            * NO: Remove the previous tetromino placement. Is there
            another rotation available?
                * YES: Place that rotation.
                * NO : Is there another tetromino available?
                    * YES: Place that tetromino in its first rotation.
                    * NO: Go to line 7 - remove the previous tetromino
                    placement. Is there another rotation available?

Okay, so this algorithm works, but it's not efficient enough. The lower
half of the board changes very infrequently compared to the upper areas,
and tetromino shapes that come early in the order get stuck at the
bottom for a long time. It's likely that all the attempts at the top,
starting with a much smaller selection of tetromino shapes, with fail.

We can solve that by shuffling up the sequence of tetrominoes, rather
than having rotations of the same shape all follow each other in the
sequence. We need to keep them in a determinate order, but with more
variation.

Also, it seems obvious (or at least likely) that the edges of the
rectangle are a more significant filter on possible solutions than the
internal arrangement. So, instead of filling the solution row by row,
from bottom to top, it might be more efficient to work around the edges
first, and then spiral inwards. It seems intuitive that there will be
less solutions to make a perfect outside edge than there are to fill the
square up until the last few rows. By focusing on this problem first, we
can probably eliminate a great many possibilities much earlier.

That will require some adjustment to the positioning logic. If working
left to right, then bottom to top, the root square must be the lowest,
then leftmost square. However, when switching direction to go from
bottom to top at the end of that first row, we are now effectively going
from bottom to top, right to left, so we need to designate the
rightmost, then lowest square as the root square.

Finally, I have noticed several situations where the algorithm is trying
combinations for the last 6 or so tetrominoes, but it's clear to see
that a cluster of 3 isolated blank spaces in the top left corner, or a
collection of 6 blank spaces arranged like an inverted version of the
Cyrillic letter Tse, or a lowercase N with a tick, in a 2x4 grid, cannot
be legally filled. This means none of the attempts being made to fill
the spaces in lower rows will ultimately be successful.

Solving this problem though would require an extra step of checking, and
likely include various other possibility. That could be expensive, and
it may not be as urgent following the aforementioned improvements.

Speaking of computational expense, it will be faster to calculate a
mixed list of tetromino rotations and re-use it that calculate rotations
as part of each iteration, but the more important optimisation at this
stage seems like it would be to find ways of eliminating solution trees
as early as possible.

A generalisation of the "isolated 3 spaces" problem could be to say that
all contiguous blank spaces must total a number divisible by four. If
not, then we can be certain that the tree is unsolvable.
