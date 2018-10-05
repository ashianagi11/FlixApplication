//
//  PosterViewController.swift
//  FlixApplication
//
//  Created by Ashia Nagi on 10/4/18.
//  Copyright © 2018 Ashia Nagi. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 4
        let interItemSpacing = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        
        let width = collectionView.frame.size.width / cellsPerLine -
            (interItemSpacing / cellsPerLine)
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        
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
                self.collectionView.reloadData()
               // self.refreshControl.endRefreshing()
             
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseUrlString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseUrlString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell){
            let movie = movies[indexPath.item]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    


}
