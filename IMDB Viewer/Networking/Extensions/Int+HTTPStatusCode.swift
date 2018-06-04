//
//  NetworkClient.swift
//  IMDB Viewer
//
//  Created by Juan Pablo Lazcano Candia on 6/2/18.
//  Copyright © 2018 Juan Pablo Lazcano Candia. All rights reserved.
//


extension Int {
  public var isSuccessHTTPCode: Bool {
    return 200 <= self && self < 300
  }
}
