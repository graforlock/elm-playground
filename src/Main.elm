import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task
import Set exposing (Set)


main =
  App.program
    { init = init "sexy ass"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  , error : String
  , history : Set String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" "" (Set.fromList [topic])
  , getRandomGif topic
  )



-- UPDATE


type Msg
  = MorePlease
  | FetchSucceed String
  | FetchFail Http.Error
  | UpdateTopic String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      ({model | history = (Set.insert model.topic model.history) }, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl "" model.history, Cmd.none)

    FetchFail _ ->
      (Model model.topic "" "Fetch error!" model.history, Cmd.none)

    UpdateTopic newTopic ->
      ({model | topic = newTopic }, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , input [ onInput UpdateTopic ] []
    , br [] []
    , select []
      (List.map toOption (Set.toList model.history))
    , img [src model.gifUrl] []
    , p [] [text model.error]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string

-- DOM

toOption: String -> Html Msg
toOption topic =
   option [] [text topic]