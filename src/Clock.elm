import Html exposing (Html, div, button)
import Html.Events exposing (onClick)
import Html.App as App
import VirtualDom exposing (Node)
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

type alias Model = { time: Time, playing: Bool }

init : (Model, Cmd Msg)
init =
  (Model 0 True, Cmd.none)

--UPDATE

type Msg
    = Tick Time
    | Toggle

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            if model.playing == True then
                (Model newTime model.playing, Cmd.none)
            else
                (Model model.time model.playing, Cmd.none)

        Toggle ->
            ({ model | playing = not(model.playing) }, Cmd.none)

--SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



--VIEW

view: Model -> Html Msg
view model =
      let
        angle =
          { sec = turns (Time.inMinutes model.time)
          , min = turns (Time.inHours model.time)
          }
      in
        div [] [
            svg [ viewBox "0 0 100 100", width "300px" ]
              [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
              , drawLines angle.sec model.playing
              , drawLines angle.min model.playing
              ]
            , button [ onClick Toggle ] [ text "Toggle" ]
            ]

--SVG

drawLines: Float -> Bool -> Node a
drawLines angle play =
    let ( handX, handY ) =
          ( toString (50 + 40 * cos angle), toString (50 + 40 * sin angle) )
    in
        line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []



