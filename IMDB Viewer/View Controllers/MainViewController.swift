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
  @IBOutlet weak var movieTableView: UITableView!{
    didSet{
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(loadMovies), for: .valueChanged)
      movieTableView.refreshControl = refreshControl
    }
  }
  // MARK: - Injections
  internal var networkClient = NetworkClient.shared
  // MARK: - Instance Properties
  internal var imageTasks: [IndexPath: URLSessionDataTask] = [:]
  internal var movies: [Movie] = []
  internal let session = URLSession.shared
  internal var defaultFilterType : Movie.SortMovieBy = .popular
  internal let imageCache = NSCache<NSString, UIImage>()
  internal let segueId = "MovieDetail"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.movieTableView.delegate = self
    self.movieTableView.dataSource = self
    configureTableView()
    loadMovies()
  }
  @IBAction func changeFilter(_ sender: Any) {
    if defaultFilterType == .popular {
      defaultFilterType = .topRated
    }else {
      defaultFilterType = .popular
    }
    loadMovies()
  }
  
  override func didReceiveMemoryWarning() {
    //the cache can be recreated
    imageCache.removeAllObjects()
  }
  
  @objc internal func loadMovies() {
    movieTableView.refreshControl?.beginRefreshing()
    networkClient.getMovies(forType: defaultFilterType, success: { [weak self] movies in
      guard let strongSelf = self else { return }
      strongSelf.movies = movies
      strongSelf.movieTableView.reloadData()
      strongSelf.movieTableView.refreshControl?.endRefreshing()
      
      }, failure: { [weak self] error in
        guard let strongSelf = self else { return }
        strongSelf.movieTableView.refreshControl?.endRefreshing()
        print("Movie download failed: \(error)")
    })
  }
  
  private func configureTableView() {
    movieTableView.tableFooterView = UIView()
  }
  
  // MARK: - Segue
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let viewController = segue.destination as? MovieDetailViewController else { return }
    if let index = sender as? Int{
      let movie = movies[index]
      viewController.movie = movie
      if let cachedImage = imageCache.object(forKey: movie.posterPath.description as NSString) {
        //if the image is already downloaded, the detail view gets the image from the cache
        viewController.moviePoster = cachedImage
      }
    }
  }
  
}

// MARK: - UITableView

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //fixed row height, needs to be refactor into a constant
    return 320
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MovieTableViewCell =  movieTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell ?? MovieTableViewCell()
    // Delegate cell button tap events to this view controller
    cell.delegate = self
    let movie = movies[indexPath.row]
    if let cachedImage = imageCache.object(forKey: movie.posterPath.description as NSString) {
      print("image in cache no need to download again")
      cell.moviePosterImg.image = cachedImage
      cell.downloadIndicator.stopAnimating()
    }else{
      let task = session.dataTask(with: movie.posterPath, completionHandler: { [weak cell]
        (data, response, error) in
        if let error = error {
          print("Image download failed: \(error)")
          return
        }
        guard let cell = cell,
          let data = data,
          let image = UIImage(data: data) else {
            print("Image download failed: invalid image data!")
            return
        }
        DispatchQueue.main.async { [weak cell] in
          guard let cell = cell else { return }
          self.imageCache.setObject(image, forKey: movie.posterPath.description as NSString)
          cell.moviePosterImg.image = image
          cell.downloadIndicator.stopAnimating()
        }
      })
      imageTasks[indexPath] = task
      task.resume()
    }
    cell.configure(withMovie: movie, index :indexPath.row)
    return cell
  }
  
}
// MARK: - MovieCellDelegate
extension MainViewController: MovieCellDelegate {
  func showMovieDetails(_ index: Int){
       performSegue(withIdentifier: segueId, sender: index)
  }
}


