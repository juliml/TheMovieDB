//
//  MoviesViewController.swift
//  TheMovieDB
//
//  Created by Juliana Lima on 29/10/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableMovies: UITableView!
    
    var arrMovies = [Movie]()
    var currentPage:Int = 0
    var totalPages:Int = 0
    
    let searchBarMovie = UISearchBar()
    var arrMoviesSearch = [Movie]()
    var currentPageSearch:Int = 0
    var totalPagesSearch:Int = 0
    var querySearch:String = ""
    
    var searchingNow:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        
        //Add searchBar in navigationBar
        searchBarMovie.showsCancelButton = false
        searchBarMovie.placeholder = "Search your movie here!"
        searchBarMovie.delegate = self
        
        navigationItem.titleView = searchBarMovie
        
        self.loadMovies(page: 1)
        
    }
    
    //MARK: LoadMovies upcoming
    func loadMovies(page:Int) {
        
        currentPage = page

        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.isUserInteractionEnabled = false;
        
        TMDBManager.sharedInstance.fetchMovies(queryUrl: TMDBManager.movie_queries.upcomingMovies, page: page) { (movies, totalPages) in
            
            self.totalPages = totalPages
            
            spinnerActivity.hide(animated: true);
            self.arrMovies.append(contentsOf: movies)
            self.tableMovies.reloadData()
        }
        
    }
    
    //MARK: SearchMovie by query
    func searchMovie(query:String, page:Int) {
        
        currentPageSearch = page
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Searching";
        spinnerActivity.isUserInteractionEnabled = false;
        
        TMDBManager.sharedInstance.fetchSearchMovie(query: query, page: page) { (movies, totalPages) in
            
            self.totalPages = totalPages
            
            spinnerActivity.hide(animated: true);
            self.arrMoviesSearch.append(contentsOf: movies)
            self.tableMovies.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: SearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBarMovie.showsCancelButton = true
        searchingNow = true
        
        tableMovies.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBarMovie.showsCancelButton = false
        searchingNow = false
        
        searchBarMovie.endEditing(true)
        searchBarMovie.text = ""
        
        arrMoviesSearch = []
        currentPageSearch = 0
        
        tableMovies.scrollIndicatorInsets = UIEdgeInsets.zero
        tableMovies.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        querySearch = searchBar.text!
        searchMovie(query: querySearch, page: 1)
        searchBarMovie.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBarMovie.endEditing(true)
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingNow {
            return arrMoviesSearch.count
        } else {
            return arrMovies.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = arrMovies.count - 1
        if indexPath.row == lastElement {
            if searchingNow {
                if currentPageSearch < totalPagesSearch {
                    currentPageSearch += 1
                    searchMovie(query: querySearch, page: currentPageSearch)
                }
            } else {
                if currentPage < totalPages {
                    currentPage += 1
                    loadMovies(page: currentPage)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMovie", for: indexPath as IndexPath) as! MovieTableViewCell
        
        let movie:Movie = getMovie(row: indexPath.row)
        cell.setData(movie: movie)
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie:Movie = getMovie(row: indexPath.row)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let viewDetail:MovieDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "movieDetail") as! MovieDetailViewController;
        viewDetail.movieData = movie
        
        self.navigationController?.pushViewController(viewDetail, animated: true)
    }
    
    //MARK: Get movie indexPath.row
    func getMovie(row:Int) -> Movie {
        
        let movie:Movie
        
        if searchingNow {
            movie = arrMoviesSearch[row]
        } else {
            movie = arrMovies[row]
        }
        
        return movie
        
    }


}
