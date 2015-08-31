module App where
{-| This is the main app!  -}
import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import StartApp
import Van exposing (Van)
import Signal exposing (Address, forwardTo)

-- TYPES

type alias Model = { vans : List Van }

type alias Action = (Int, Van.RidingState)

-- FUNCTIONS

model : Model
model = 
  {vans = 
    [{ number = 1
     , state = Van.Undecided } ] }

to_van_address : Address Action -> Address Van.Action
to_van_address address = 
  Signal.Address.map snd address

view : Address Action -> Model -> Html.Html
view address model =
  let van_address = address |> to_van_address in
      div [] (List.map (Van.view van_address) model.vans)

action_to_str : Action -> String
action_to_str (_, state) = 
  Van.riding_state_to_str state

update_van : Action -> Van -> Van
update_van (num, state) van = 
  if num == van.number
    then Van.update state van
    else van

update : Action -> Model -> Model
update action {vans} = 
  let new_vans = List.map (update_van action) vans in
  { model | vans <- new_vans}

main = StartApp.start { model = model, view = view, update = update }
