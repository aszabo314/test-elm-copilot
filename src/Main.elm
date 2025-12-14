module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, p, button, text)
import Html.Events exposing (onClick)


-- MODEL

type alias Model =
    { count : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { count = 0 }, Cmd.none )


-- UPDATE

type Msg
    = Increment
    | Decrement
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        Reset ->
            ( { model | count = 0 }, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
    div [ Html.Attributes.class "container" ]
        [ h1 [] [ text "Elm Counter App" ]
        , div [ Html.Attributes.class "counter-display" ]
            [ text (String.fromInt model.count) ]
        , div [ Html.Attributes.class "button-group" ]
            [ button [ onClick Decrement, Html.Attributes.class "btn" ] [ text "-" ]
            , button [ onClick Reset, Html.Attributes.class "btn" ] [ text "Reset" ]
            , button [ onClick Increment, Html.Attributes.class "btn" ] [ text "+" ]
            ]
        , p [ Html.Attributes.class "description" ]
            [ text "A simple counter app built with Elm, compiled with GitHub Actions, and deployed to GitHub Pages!" ]
        ]


-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
