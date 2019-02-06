//
//  DataResponseError.swift
//  IMDB Viewer
//
//  Created by SpaceGhost on 2/5/19.
//  Copyright © 2019 Juan Pablo Lazcano Candia. All rights reserved.
//
import Foundation

enum DataResponseError: Error {
  case network
  case decoding

  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data "
    case .decoding:
      return "An error occurred while decoding data"
    }
  }
}
