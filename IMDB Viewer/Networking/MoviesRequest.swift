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

    let parameters: Parameters
    private init(parameters: Parameters, path: String = "popular") {
        self.parameters = parameters
        self.path = path
    }
}

extension MoviesRequest {
    static func popularMovies() -> MoviesRequest {
        let parameters = ["api_key": "34738023d27013e6d1b995443764da44"]
        return MoviesRequest(parameters: parameters)
    }

    static func topRated() -> MoviesRequest {
        let parameters = ["api_key": "34738023d27013e6d1b995443764da44"]
        return MoviesRequest(parameters: parameters, path: "top_rated")
    }
}
