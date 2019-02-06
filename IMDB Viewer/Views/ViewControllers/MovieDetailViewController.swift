//
//  MovieDetailViewController.swift
//  IMDB Viewer
//
//  Created by Juan Pablo Lazcano Candia on 6/4/18.
//  Copyright © 2018 Juan Pablo Lazcano Candia. All rights reserved.
//

import SDWebImage
import UIKit

class MovieDetailViewController: UIViewController {
    public var movie: Movie!
    public var moviePoster: UIImage?
    
    @IBOutlet var movieTitleLbl: UILabel!
    @IBOutlet var posterImg: UIImageView!
    @IBOutlet var movieOverviewTxt: UITextView!
    @IBOutlet var scoreLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMovieData()
    }
    
    private func downloadImage() {
        posterImg.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"),
                              placeholderImage: UIImage(named: "MoviePlaceholder"))
    }
    
    private func setMovieData() {
        downloadImage()
        movieOverviewTxt.text = movie.overview
        movieTitleLbl.text = movie.title
        scoreLbl.text = "\(movie.voteAverage) / 10"
    }
}
