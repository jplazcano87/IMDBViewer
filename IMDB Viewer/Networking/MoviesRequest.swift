//
//  DataResponseError.swift
//  IMDB Viewer
//
//  Created by SpaceGhost on 2/5/19.
//  Copyright © 2019 Juan Pablo Lazcano Candia. All rights reserved.
//
import Foundation

struct MoviesRequest {
    var path: String
    let parameters: Parameters = ["api_key": "34738023d27013e6d1b995443764da44"]
    private init(path: String = "popular") {
        self.path = path
    }
}

extension MoviesRequest {
    static func popularMovies() -> MoviesRequest {
        return MoviesRequest()
    }

    static func topRated() -> MoviesRequest {
        return MoviesRequest(path: "top_rated")
    }
}
