import Html exposing (Html)
import Html.App as App
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

--MODEL

type alias Model = Time

init : (Model, Cmd Msg)
init =
  (0, Cmd.none)

--UPDATE

type Msg = Tick Time

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick Time ->
            (model, Cmd.none)


--VIEW

--SUBSCRIPTIONS
