//
//  DataResponseError.swift
//  IMDB Viewer
//
//  Created by SpaceGhost on 2/5/19.
//  Copyright © 2019 Juan Pablo Lazcano Candia. All rights reserved.
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
    //todo use the base url from the plist and format this url
    case .popular:
      tempUrl = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(self.apiKey)")!
    case .topRated:
      tempUrl = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(self.apiKey)")!
    }
  
    session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
   
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.hasSuccessStatusCode,
            let data = data
            else {
                completion(Result.failure(DataResponseError.network))
                return
        }
        
   
        guard let decodedResponse = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
            completion(Result.failure(DataResponseError.decoding))
            return
        }
        
   
        completion(Result.success(decodedResponse))
    }).resume()
  }
  
}
