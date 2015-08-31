module StartApp where
{-| This module makes it super simple to get started making a typical web-app.
It is designed to work perfectly with [the Elm Architecture][arch] which
describes a simple architecture pattern that makes testing and refactoring
shockingly pleasant. Definititely read [the tutorial][arch] to get started!

[arch]: https://github.com/evancz/elm-architecture-tutorial/

# Define your App
@docs App

# Run your App
@docs start

-}

import Html exposing (Html)
import Signal exposing (Address)

{-| This is a comment for App -}
type alias App model action =
    { model : model
    , view : Address action -> model -> Html
    , update : action -> model -> model
    }

{-| Start: is what starts it off -}
start : App model action -> Signal Html
start app =
  let
    actions =
      Signal.mailbox Nothing

    address =
      Signal.forwardTo actions.address Just

    model =
      Signal.foldp
        (\(Just action) model -> app.update action model)
        app.model
        actions.signal
  in
    Signal.map (app.view address) model
