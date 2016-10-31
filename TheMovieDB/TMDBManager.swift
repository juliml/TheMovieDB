//
//  TMDBManager.swift
//  TheMovieDB
//
//  Created by Juliana Lima on 29/10/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TMDBManager {
    
    static let sharedInstance = TMDBManager()
    
    let api_key         = "1f54bd990f1cdfb230adb312546d765d"
    let base_apiUrl     = "https://api.themoviedb.org/3"
    let base_imageUrl   = "http://image.tmdb.org/t/p"
    
    enum movie_queries:String {
        case upcomingMovies     = "https://api.themoviedb.org/3/movie/upcoming"
        case topRatedMovies     = "https://api.themoviedb.org/3/movie/top_rated"
        case popularMovies      = "https://api.themoviedb.org/3/movie/popular"
        case nowPlayingMovies   = "https://api.themoviedb.org/3/movie/now_playing"
    }
    
    let search_query = "https://api.themoviedb.org/3/search/movie"
    
    
    //MARK: Fetch movies by category
    func fetchMovies(queryUrl:movie_queries, page:Int, handler: @escaping (_ result:[Movie], _ totalPages:Int)->Void){

        let parameters: Parameters = ["api_key": api_key, "page": page]
        
        Alamofire.request(queryUrl.rawValue, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{

                    var movies = [Movie]()
                    let json = JSON(data)
                    //print(json)
                    
                    for (_,subJson) in json["results"] {
                        movies.append(Movie(rawData: subJson))
                    }
                    
                    handler(movies, json["total_pages"].int!)
                }
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
           
        }
        
    }
    
    //MARK: Fetch movies by search query
    func fetchSearchMovie(query:String, page:Int, handler: @escaping (_ result:[Movie], _ totalPages:Int)->Void){
        
        let parameters: Parameters = ["api_key": api_key, "page": page, "query": query, "primary_release_year":2016]
        
        Alamofire.request(search_query, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    var movies = [Movie]()
                    let json = JSON(data)

                    for (_,subJson) in json["results"] {
                        movies.append(Movie(rawData: subJson))
                    }
                    
                    handler(movies, json["total_pages"].int!)
                }
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
            
        }
        
        
    }
    
}
