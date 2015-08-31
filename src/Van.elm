module Van where
{-| This represents a van -}
import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Signal exposing (Address)
import StartApp

-- TYPES

type RidingState = 
  RoundTrip | In | Out | Not | Undecided

-- Should this be the same?
type alias Action = RidingState

type alias Van = 
  { number : Int
  , state : RidingState
  }

type alias Model = Van

-- UPDATE
model : Model
model =
  { number = 1
  , state = Undecided
  }

update: Action -> Model -> Model
update action model = 
  if action == model.state
  then {model | state <- Not} 
  else {model | state <- action} 

-- VIEW

-- ride_button : Address Action -> Van -> RidingState -> Html.Html
ride_button address van rs = 
  button 
      [ onClick address rs
      , style_button van.state rs
      ]
      [ text (rs_to_pretty rs) ]


view : Address Action -> Van -> Html
view address van =
  div []
    [ ride_button address van In
    , ride_button address van Out
    , ride_button address van RoundTrip
    , div [] [ text (rs_to_pretty van.state) ]
    ]

style_button : RidingState -> RidingState -> Html.Attribute
style_button current_state set_state = 
  if current_state == set_state 
  then style [("color", "blue")]
  else style []

rs_to_pretty rs = 
  case rs of
    RoundTrip -> "Round Trip"
    In -> "In"
    Out -> "Out"
    Undecided -> "Undecided"
    Not -> "Not Riding"

riding_state_to_str : RidingState -> String
riding_state_to_str riding_state = 
  case riding_state of
    RoundTrip -> "round"
    In -> "in"
    Out -> "out"
    Undecided -> "undecided"
    Not -> "not"

main = StartApp.start { model = model, view = view, update = update }
