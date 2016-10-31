//
//  Movie.swift
//  TheMovieDB
//
//  Created by Juliana Lima on 29/10/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Movie {
    
    var id: Int
    var title: String
    var overview: String?
    var posterPath: String?
    var backdropPath: String?
    var releaseDate: Date?
    var genres: [String]?
    
    var releaseDateString: String {
        get {
            let dayTimeFormatter = DateFormatter()
            
            dayTimeFormatter.dateFormat = "dd/MM/yyyy"
            return dayTimeFormatter.string(from: self.releaseDate! as Date)
        }
    }
    
    
    init(rawData: JSON) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        self.id = rawData["id"].int!
        self.title = rawData["title"].string!
        self.overview = rawData["overview"].string
        
        if rawData["poster_path"] == nil {
            self.posterPath = "https://placeholdit.imgix.net/~text?txtsize=33&txt=300%C3%97450&w=300&h=450"
        } else {
            self.posterPath = "\(TMDBManager.sharedInstance.base_imageUrl)/w500\(rawData["poster_path"].string!)"
        }
        
        if rawData["backdrop_path"] == nil {
            self.backdropPath = "https://placeholdit.imgix.net/~text?txtsize=33&txt=533%C3%97300&w=533&h=300"
        } else {
            self.backdropPath = "\(TMDBManager.sharedInstance.base_imageUrl)/w780\(rawData["backdrop_path"].string!)"
        }
        
        self.releaseDate = dateFormater.date(from: rawData["release_date"].string!)
        
        
    }
    
    //MARK: Fetch genres of movie
    func fetchGenres(callback: @escaping (Movie) -> Void) {
        
        let parameters: Parameters = ["api_key": TMDBManager.sharedInstance.api_key]
        let url:String = "\(TMDBManager.sharedInstance.base_apiUrl)/movie/\(id)"
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    self.genres = [String]()
                    let json = JSON(data)
                    for (_,genreRawData) in json["genres"] {
                        self.genres?.append(genreRawData["name"].string!)
                    }

                    callback(self)
                }
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
            
        }

    }
    
}
