//
//  MoviesViewModel.swift
//  IMDB Viewer
//
//  Created by SpaceGhost on 2/5/19.
//  Copyright © 2019 Juan Pablo Lazcano Candia. All rights reserved.
//

import Foundation

protocol MoviesViewModelDelegate: class {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

final class MoviesViewModel {
    private weak var delegate: MoviesViewModelDelegate?
    private var movies: [Movie] = []
    private let client = MovieRequestClient()
    private var request: MoviesRequest
    private var requestType : SortMovieBy = .popular
    
    public enum SortMovieBy {
        case popular
        case topRated
    }

    var totalCount: Int {
        return movies.count
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    //using a default strategy for fetch movies, this could be changed at runtime with a setter
    init(request: MoviesRequest = MoviesRequest.popularMovies(), delegate: MoviesViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    @objc func changeFilter() {
        if requestType == .popular {
            requestType = .topRated
            request =  MoviesRequest.topRated()
        } else {
            requestType = .popular
            request =  MoviesRequest.popularMovies()
        }
        
        fetchMovies()
    }
    
    func fetchMovies() {
        client.fetchMovies(with: request, page: 1) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.movies.removeAll()
                    self.movies = response.results
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }

}
