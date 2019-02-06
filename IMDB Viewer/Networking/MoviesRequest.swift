//
//  DataResponseError.swift
//  IMDB Viewer
//
//  Created by SpaceGhost on 2/5/19.
//  Copyright © 2019 Juan Pablo Lazcano Candia. All rights reserved.
//
import Foundation

struct MoviesRequest {
  var path: String {
    return "popular"
  }
  
  let parameters: Parameters
  private init(parameters: Parameters) {
    self.parameters = parameters
  }
}

extension MoviesRequest {
  static func from(site: String = "") -> MoviesRequest {
    let parameters = ["api_key": "34738023d27013e6d1b995443764da44"]
    return MoviesRequest(parameters: parameters)
  }
}
