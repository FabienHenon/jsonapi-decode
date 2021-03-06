module JsonApi.DocumentTest exposing (suite)

import Dict exposing (Dict)
import Expect exposing (Expectation)
import Json.Encode exposing (bool, encode, object, string)
import JsonApi.Encode.Document exposing (Document, build, jsonApiVersion, links, meta, resource, resources, withJsonApiVersion, withLinks, withMeta, withResource, withResources)
import JsonApi.Resource exposing (Resource)
import Test exposing (..)


suite : Test
suite =
    describe "Document"
        [ test "empty document info has nothing except a json api version set to 1.0" <|
            \() ->
                build
                    |> Expect.all
                        [ jsonApiVersion >> Expect.equal "1.0"
                        , meta >> Expect.equal Nothing
                        , resource >> Expect.equal Nothing
                        , resources >> Expect.equal Nothing
                        , links >> Dict.toList >> Expect.equalLists []
                        ]
        , test "document with json api version has another version" <|
            \() ->
                build
                    |> withJsonApiVersion "2.0"
                    |> Expect.all
                        [ jsonApiVersion >> Expect.equal "2.0"
                        , meta >> Expect.equal Nothing
                        , resource >> Expect.equal Nothing
                        , resources >> Expect.equal Nothing
                        , links >> Dict.toList >> Expect.equalLists []
                        ]
        , test "document with meta has meta" <|
            \() ->
                build
                    |> withMeta (object [ ( "redirect", bool True ) ])
                    |> Expect.all
                        [ jsonApiVersion >> Expect.equal "1.0"
                        , meta >> Expect.equal (Just <| object [ ( "redirect", bool True ) ])
                        , resource >> Expect.equal Nothing
                        , resources >> Expect.equal Nothing
                        , links >> Dict.toList >> Expect.equalLists []
                        ]
        , test "document with links has links" <|
            \() ->
                build
                    |> withLinks (Dict.fromList [ ( "self", "http://root/1" ), ( "other", "http://root/2" ) ])
                    |> Expect.all
                        [ jsonApiVersion >> Expect.equal "1.0"
                        , meta >> Expect.equal Nothing
                        , resource >> Expect.equal Nothing
                        , resources >> Expect.equal Nothing
                        , links >> Dict.toList >> Expect.equalLists [ ( "other", "http://root/2" ), ( "self", "http://root/1" ) ]
                        ]
        , test "document with one resource has one resource" <|
            \() ->
                build
                    |> withResource oneRes
                    |> Expect.all
                        [ jsonApiVersion >> Expect.equal "1.0"
                        , meta >> Expect.equal Nothing
                        , resource >> Expect.equal (Just oneRes)
                        , resources >> Expect.equal (Just [ oneRes ])
                        , links >> Dict.toList >> Expect.equalLists []
                        ]
        , test "document with two resources has two resource" <|
            \() ->
                build
                    |> withResources twoRes
                    |> Expect.all
                        [ jsonApiVersion >> Expect.equal "1.0"
                        , meta >> Expect.equal Nothing
                        , resource >> Expect.equal (List.head twoRes)
                        , resources >> Expect.equal (Just twoRes)
                        , links >> Dict.toList >> Expect.equalLists []
                        ]
        ]


oneRes : Resource
oneRes =
    JsonApi.Resource.build "test-1"


twoRes : List Resource
twoRes =
    [ JsonApi.Resource.build "test-1", JsonApi.Resource.build "test-2" ]
