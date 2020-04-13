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