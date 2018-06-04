//
//  MovieDetailViewController.swift
//  IMDB Viewer
//
//  Created by Juan Pablo Lazcano Candia on 6/4/18.
//  Copyright © 2018 Juan Pablo Lazcano Candia. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  public var movie: Movie!
  public var moviePoster : UIImage?
  
  @IBOutlet weak var movieTitleLbl: UILabel!
  @IBOutlet weak var posterImg: UIImageView!
  @IBOutlet weak var movieOverviewTxt: UITextView!
  @IBOutlet weak var scoreLbl: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("loading with movie \(movie.title)")
    setMovieData()
    
  }
  
  private func downloadImage(){
    posterImg.setImage(url: movie.posterPath)
  }
  
  private func setMovieData(){
    if let _ = moviePoster{
      posterImg.image = moviePoster
    }else{
      downloadImage()
    }
    movieOverviewTxt.text = movie.overview
    movieTitleLbl.text = movie.title
    scoreLbl.text = "\(movie.voteAverage) / 10"

  }
  
}
