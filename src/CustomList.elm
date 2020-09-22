module CustomList exposing (firstAfter)


firstAfter : List a -> Maybe a -> Maybe a
firstAfter xs x =
    List.head
        (case x of
            Nothing ->
                xs

            Just justx ->
                dropUntil xs justx
        )


dropUntil : List a -> a -> List a
dropUntil list match =
    case list of
        x :: xs ->
            if x == match then
                xs

            else
                dropUntil xs match

        [] ->
            []
