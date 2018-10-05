//
//  DetailViewController.swift
//  FlixApplication
//
//  Created by Ashia Nagi on 10/2/18.
//  Copyright © 2018 Ashia Nagi. All rights reserved.
//

import UIKit

enum MovieKeys {
    static let title = "title"
    static let releaseDate = "release_date"
    static let overview = "overview"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            titleLabel.text = movie[MovieKeys.title] as? String
            releaseLabel.text = movie[MovieKeys.releaseDate] as? String
            overviewLabel.text = movie[MovieKeys.overview] as? String
            let backdropPathString = movie[MovieKeys.backdropPath] as! String
            let posterPath = movie[MovieKeys.posterPath] as! String
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
