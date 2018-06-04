//
//  NetworkClient.swift
//  IMDB Viewer
//
//  Created by Juan Pablo Lazcano Candia on 6/2/18.
//  Copyright © 2018 Juan Pablo Lazcano Candia. All rights reserved.
//

import Foundation

public final class NetworkClient {
  
  // MARK: - Instance Properties
  internal let baseURL: URL
  internal let apiKey: String
  internal let session = URLSession.shared
  
  // MARK: - Class Constructors
  public static let shared: NetworkClient = {
    let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
    let dictionary = NSDictionary(contentsOfFile: file)!
    let urlString = dictionary["base_url"] as! String
    let url = URL(string: urlString)!
    let apiKey =  dictionary["api_key"] as! String
    return NetworkClient(baseURL: url, apiKey: apiKey)
  }()
  
  // MARK: - Object Lifecycle
  private init(baseURL: URL, apiKey : String) {
    self.baseURL = baseURL
    self.apiKey = apiKey
  }
  
  public func getMovies(forType type: Movie.SortMovieBy,
                        success _success: @escaping ([Movie]) -> Void,
                        failure _failure: @escaping (NetworkError) -> Void) {
   
    let success: ([Movie]) -> Void = { movies in
      DispatchQueue.main.async { _success(movies) }
    }
    
    let failure: (NetworkError) -> Void = { error in
      DispatchQueue.main.async { _failure(error) }
    }
    
    let tempUrl : URL
    switch type {
    case .popular:
      tempUrl = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(self.apiKey)")!
    case .topRated:
      tempUrl = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(self.apiKey)")!
    }
  
    let task = session.dataTask(with: tempUrl, completionHandler: { (data, response, error) in
      var movies: [Movie] = []
      guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode.isSuccessHTTPCode,
        let data = data,
        let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
          if let error = error {
            failure(NetworkError(error: error))
          } else {
            failure(NetworkError(response: response))
          }
          return
      }
      
      for case let result in jsonObject!["results"] as! [[String : Any]] {
        if let movie = try? Movie(json: result) {
          movies.append(movie)
        }
      }
      success(movies)
    })
    
    task.resume()
  }
  
}
