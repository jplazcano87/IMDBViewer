//
//  ViewController.swift
//  IMDB Viewer
//
//  Created by Juan Pablo Lazcano Candia on 6/2/18.
//  Copyright © 2018 Juan Pablo Lazcano Candia. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var movieTableView: UITableView! {
        didSet {
            let refreshControl = UIRefreshControl()
            //  refreshControl.addTarget(self, action: #selector(loadMovies), for: .valueChanged)
            movieTableView.refreshControl = refreshControl
        }
    }
    
    // MARK: - Injections
    
    internal var networkClient = MovieRequestClient()
    
    // MARK: - Instance Properties
    
    private var viewModel: MoviesViewModel!
    var site: String!
    
    internal var imageTasks: [IndexPath: URLSessionDataTask] = [:]
    internal let imageCache = NSCache<NSString, UIImage>()
    internal let segueId = "MovieDetail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        let request = MoviesRequest.from()
        viewModel = MoviesViewModel(request: request, delegate: self)
        viewModel.fetchMovies()
        
        configureTableView()
    }
    
    @IBAction func changeFilter(_ sender: Any) {
//        if defaultFilterType == .popular {
//            defaultFilterType = .topRated
//        } else {
//            defaultFilterType = .popular
//        }
//        loadMovies()
    }

    
    private func configureTableView() {
        movieTableView.tableFooterView = UIView()
    }
    
    // MARK: - Segue
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? MovieDetailViewController else { return }
        if let index = sender as? Int {
//            let movie = movies[index]
//            viewController.movie = movie
//            if let cachedImage = imageCache.object(forKey: movie.posterPath.description as NSString) {
//                // if the image is already downloaded, the detail view gets the image from the cache
//                viewController.moviePoster = cachedImage
//            }
        }
    }
}

extension MainViewController: MoviesViewModelDelegate {
    func onFetchCompleted(){
       movieTableView.reloadData()
        
    }
    func onFetchFailed(with reason: String){
        
    }
}

// MARK: - UITableView

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // fixed row height, needs to be refactor into a constant
        return 320
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieTableViewCell = movieTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell ?? MovieTableViewCell()
        // Delegate cell button tap events to this view controller
        cell.delegate = self

        
        cell.configure(withMovie: viewModel.movie(at: indexPath.row), index: indexPath.row)
        
        return cell
    }
}

// MARK: - MovieCellDelegate

extension MainViewController: MovieCellDelegate {
    func showMovieDetails(_ index: Int) {
        performSegue(withIdentifier: segueId, sender: index)
    }
}
