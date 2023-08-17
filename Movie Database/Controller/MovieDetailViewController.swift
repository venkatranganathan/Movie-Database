//
//  MovieDetailViewController.swift
//  Movie Database
//
//  Created by M_AMBIN06088 on 16/08/23.
//

import UIKit
import SwiftUI

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieDirectors: UILabel!
    @IBOutlet weak var movieWriters: UILabel!
    @IBOutlet weak var movieActors: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var ratingControl: UISegmentedControl!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var movieRatings: UILabel!
    @IBOutlet weak var movieScrollView: UIScrollView!
    var movieItem: MovieData?
    var offSet: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadItem()
    }
    
    func loadItem(){
        if let item = movieItem {
            movieTitle?.text = item.Title
            moviePlot?.text = item.Plot
            movieDate?.text = item.Released
            movieGenre?.text = item.Genre
            movieRating?.text = item.Rated
            if(item.Poster != "" && item.Poster != "N/A"){
                moviePoster?.load(urlString: item.Poster)
            }
            movieDirectors?.text = item.Director
            movieWriters?.text = item.Writer
            movieActors?.text = item.Actors
        }
    }
    
    @IBAction func ratingValueChanged(_ sender: Any) {
        if(ratingControl.selectedSegmentIndex == 0)
        {
            if let results = movieItem?.Ratings.filter({ $0.Source == "Internet Movie Database" }), results.count > 0 {
                if let rating = Float(movieItem!.imdbRating) {
                    hideRatingSelect()
                    showProgress(rating/10.0, _val: results[0].Value)
                    return
                }
            }
            showNoRating()
        }
        else if(ratingControl.selectedSegmentIndex == 1)
        {
            if let results = movieItem?.Ratings.filter({ $0.Source == "Rotten Tomatoes" }), results.count > 0 {
                if let rating = Int(results[0].Value.replacingOccurrences(of: "%", with: "")) {
                    hideRatingSelect()
                    showProgress(Float(rating)/100.0, _val: results[0].Value)
                    return
                }
            }
            showNoRating()
        }
        else if(ratingControl.selectedSegmentIndex == 2)
        {
            if let results = movieItem?.Ratings.filter({ $0.Source == "Metacritic" }), results.count > 0 {
                if let rating = Int(movieItem!.Metascore) {
                    hideRatingSelect()
                    showProgress(Float(rating)/100.0, _val: results[0].Value)
                    return
                }
            }
            showNoRating()
        }
        
    }
    
    func showProgress(_ _pVal: Float, _val: String){
        let progress = ProgressView(progressValue: _pVal, value: _val)
        self.host(component: AnyView(progress), into: ratingView)
        if(offSet == 0.0){
            offSet = movieScrollView.contentSize.height*1.1
        }
        let bottomOffset = CGPoint(x: 0, y:offSet  - movieScrollView.bounds.size.height)
        movieScrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    func hideRatingSelect(){
        movieRatings.isHidden = true
    }
    
    func showNoRating(){
        ratingView.subviews.forEach { $0.tag != 555 ? $0.removeFromSuperview() : nil }
        movieRatings.isHidden = false
        movieRatings?.text = "No Rating Available"
    }
}
