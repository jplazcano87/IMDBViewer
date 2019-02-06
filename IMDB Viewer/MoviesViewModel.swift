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
    private var isFetchInProgress = false
    
    let client = MovieRequestClient()
    let request: MoviesRequest
    
    var totalCount: Int {
        return movies.count
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    init(request: MoviesRequest, delegate: MoviesViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    func fetchMovies() {
        client.fetchMovies(with: request, page: 1) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
                
            case .success(let response):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.movies = response.results
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }

}
