//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Juliana Lima on 30/10/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRelease: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    public var movieData: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change Button Back
        let backbutton = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        backbutton.setImage(UIImage(named: "ic_backspace"), for: .normal)
        backbutton.addTarget(self, action:#selector(MovieDetailViewController.backAction),for:.touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        loadData()
        
    }
    
    func loadData() {
        
        movieTitle.text = movieData.title
        movieRelease.text = String(movieData.releaseDateString)
        
        let url = URL(string: movieData.posterPath!)
        
        moviePoster.af_setImage(
            withURL: url!,
            placeholderImage: nil,
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
        
        movieData.fetchGenres { (movieWithGenres) in
            self.movieGenres.text = movieWithGenres.genres?.joined(separator: ", ")
        }
        
        movieOverview.text = movieData.overview
    }
    
    func backAction(){
         let _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
