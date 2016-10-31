//
//  MovieTableViewCell.swift
//  TheMovieDB
//
//  Created by Juliana Lima on 29/10/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRelease: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(movie:Movie) {
        
        movieTitle.text = movie.title
        movieRelease.text = String(movie.releaseDateString)
        
        moviePoster.image = UIImage()
        let url = URL(string: movie.posterPath!)
        
        moviePoster.af_setImage(
            withURL: url!,
            placeholderImage: nil,
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
        
        movie.fetchGenres { (movieWithGenres) in
            self.movieGenre.text = movieWithGenres.genres?.joined(separator: ", ")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
