//
//  MovieRequestClient.swift
//  IMDB Viewer
//
//  Created by SpaceGhost on 2/5/19.
//  Copyright © 2019 Juan Pablo Lazcano Candia. All rights reserved.
//
import Foundation

final class MovieRequestClient {
    
  private lazy var baseURL: URL = {
    return URL(string: "https://api.themoviedb.org/3/movie/")!
  }()
  
  let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func fetchMovies(with request: MoviesRequest, page: Int, completion: @escaping (Result<MoviesResponse, DataResponseError>) -> Void) {
    let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
    let encodedURLRequest = urlRequest.encode(with: request.parameters)
    print(encodedURLRequest)
   
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
