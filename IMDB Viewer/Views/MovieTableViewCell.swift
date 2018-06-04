//
//  MovieTableViewCell.swift
//  IMDB Viewer
//
//  Created by Juan Pablo Lazcano Candia on 6/3/18.
//  Copyright © 2018 Juan Pablo Lazcano Candia. All rights reserved.
//

import UIKit
//Protocol to handle button click inside the cell
protocol MovieCellDelegate {
  func showMovieDetails(_ index: Int)
}

class MovieTableViewCell: UITableViewCell {
  
  @IBOutlet weak var moviePosterImg: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
  var delegate: MovieCellDelegate?
  var index : Int?
  
  @IBAction func detailButtonTaped(_ sender: Any) {
    if let index = index {
      delegate?.showMovieDetails(index)
    }
  }
  
  func configure(withMovie movie : Movie, index : Int){
    self.titleLbl.text = movie.title
    self.index = index
  }
  
}
