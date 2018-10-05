//
//  NowPlayingViewController.swift
//  FlixApplication
//
//  Created by Ashia Nagi on 9/29/18.
//  Copyright © 2018 Ashia Nagi. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var searchingBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [[String: Any]] = []
    var filteredMovies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        searchingBar.delegate = self
        filteredMovies = movies
        fetchMovies()

    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    func fetchMovies() {
       
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=6a6c894da15025c647e619f1b8e9613b&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Cannot Display Movie", message: "Please check internet connection", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    print("error")
                })
                alertController.addAction(cancelAction)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    print("error")
                })
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movie = dataDictionary["results"] as! [[String: Any]]
                self.movies = movie
                self.filteredMovies = movie
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.title.text = title
        cell.overview.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseUrlString =  "https://image.tmdb.org/t/p/w500"
        let posterUrl = URL(string: baseUrlString + posterPathString)!
        cell.posterImage.af_setImage(withURL: posterUrl)

        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
}
