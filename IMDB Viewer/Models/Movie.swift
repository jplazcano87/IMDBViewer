//
//  Movie.swift
//  IMDB Viewer
//
//  Created by Juan Pablo Lazcano Candia on 6/2/18.
//  Copyright © 2018 Juan Pablo Lazcano Candia. All rights reserved.
//

import Foundation

enum SerializationError: Error {
  case missing(String)
}

public struct Movie {
  
  // MARK: - Constants
  public enum SortMovieBy: String {
    case popular = "popular"
    case topRated = "top_rated"
  }
  
  let voteCount : Int
  let id : Int
  let video : Bool
  let voteAverage : Double
  let title : String
  let popularity : Double
  let posterPath : URL
  let originalLanguage : String
  let originalTitle : String
  let genreIds :[Int]
  let backdropPath : String
  let adult : Bool
  let overview : String
  let releaseDate : String
  
}
extension Movie {
  init(json: [String: Any]) throws  {
    guard let voteCount =  json["vote_count"] as? Int else {
      
      throw SerializationError.missing("vote_count")
    }
    guard let id  =  json["id"] as? Int else {
      
      throw SerializationError.missing("id")
    }
    guard let video = json["video"] as? Bool else {
      
      throw SerializationError.missing("video")
    }
    guard let voteAverage = json["vote_average"] as? Double else {
      
      throw SerializationError.missing("voteAverage")
    }
    guard let title = json["title"] as? String else {
      
      throw SerializationError.missing("name")
    }
    guard let popularity = json["popularity"] as? Double else {
      
      throw SerializationError.missing("popularity")
    }
  
    guard let posterPathString = json["poster_path"] as? String else {
      
      throw SerializationError.missing("poster_path")
    }
    guard let originalLanguage = json["original_language"] as? String else {
      
      throw SerializationError.missing("original_language")
    }
    guard let originalTitle = json["original_title"] as? String else {
      
      throw SerializationError.missing("original_title")
    }
    guard let genreIds = json["genre_ids"] as? [Int] else {
      
      throw SerializationError.missing("genre_ids")
    }
    guard let backdropPath = json["backdrop_path"] as? String else {
      
      throw SerializationError.missing("name")
    }
    guard let adult = json["adult"] as? Bool else {
      
      throw SerializationError.missing("adult")
    }
    guard let overview =  json["overview"] as? String else {
      
      throw SerializationError.missing("overview")
    }
    guard let releaseDate = json["release_date"] as? String else {
      
      throw SerializationError.missing("releaseDate")
    }
    
    self.voteCount = voteCount
    self.id = id
    self.video = video
    self.voteAverage = voteAverage
    self.title = title
    self.popularity = popularity
    self.posterPath = URL(string:"https://image.tmdb.org/t/p/w500\(posterPathString)")! // the base url can be refactor as a constant
    self.originalLanguage = originalLanguage
    self.originalTitle = originalTitle
    self.genreIds = genreIds
    self.backdropPath = backdropPath
    self.adult = adult
    self.overview = overview
    self.releaseDate = releaseDate
   
  }
}
