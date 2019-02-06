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

    @IBOutlet var movieTableView: UITableView!
    
    // MARK: - Injections
    
    internal var networkClient = MovieRequestClient()
    // MARK: - Instance Properties
    
    private var viewModel: MoviesViewModel!
    internal let segueId = "MovieDetail"

    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        viewModel = MoviesViewModel(delegate: self)
        viewModel.fetchMovies()
        
        configureTableView()
    }

    @IBAction func changeFilter(_ sender: Any) {
        viewModel.changeFilter()
    }

    private func configureTableView() {
        movieTableView.tableFooterView = UIView()
    }

    // MARK: - Segue
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? MovieDetailViewController else { return }
        if let index = sender as? Int {
            viewController.movie = viewModel.movie(at: index)
        }
    }
}

extension MainViewController: MoviesViewModelDelegate {
    func onFetchCompleted() {
        movieTableView.reloadData()
    }
    func onFetchFailed(with reason: String) {
        let alert = UIAlertController(title: "Error", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "try again", style: .default, handler: {  _ in
            self.viewModel.fetchMovies()
        }))
        self.present(alert, animated: true)
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
        let cell: MovieTableViewCell = movieTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
            as? MovieTableViewCell ?? MovieTableViewCell()
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
