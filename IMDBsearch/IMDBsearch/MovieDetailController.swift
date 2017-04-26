//
//  MovieDetailController.swift
//  IMDBsearch
//
//  Created by Anita Ilieva on 27/11/2016.
//  Copyright © 2016 Anita Ilieva. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class MovieDetailController: UIViewController {
   
    @IBOutlet weak var plotTxt: UITextView!
    @IBOutlet weak var ratingLbl: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    
    var favoriteViewController : FavoriteMoviesController?=nil
    var theMovieTitle: String!
    var theMovieYear: String!

    
    var detailItem: Movie? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            self.theMovieTitle = detail.title
            self.theMovieYear = detail.year
            updateDetail(detail.id)
            if detail.posterPath != "" {
                if let imageView = self.movieImage{
                    imageView.image = detail.mainImage
              }
                if let img = self.background{
                    img.image = detail.mainImage
                }
            }
        }
    }

    func updateDetail(_ id: String){
        let url = URL(string:"http://www.omdbapi.com/?plot=short&tomatoes=true&r=json&i=" + id)!
        let json = JSON(data: try! Data(contentsOf: url))
        
        if let error = json["Error"].string{
            print(error)
        } else {
            let title = String(describing: json["Title"])
            
            if let label = self.movieTitle {
                label.text = title
            }
            let year = String(describing: json["Year"])
            
            if let label = self.movieYear {
                label.text = "Year: " + year
            }
            
            let rating = String(describing: json["imdbRating"])
            
            if let label = self.ratingLbl {
                label.text = "Rating: " + rating + "/10"
            }

            let plot = String(describing: json["Plot"])
            
            if let label = self.plotTxt{
                label.text = plot
                
            }
        }
    }

    override func viewDidLoad() {
        
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: Selector(extendedGraphemeClusterLiteral: "saveMovieToList"))

        if let tabBar = self.tabBarController {
            let controllers = tabBar.viewControllers
            self.favoriteViewController = controllers![controllers!.count-1] as? FavoriteMoviesController
        }
        self.configureView()

    }

    func saveMovieToList(){
        self.favoriteViewController?.saveItem(movieTitle: theMovieTitle, movieYear: theMovieYear)
        
        let alertController = UIAlertController(title: "Movie saved", message: "The movie has been added to your favorite movies!", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: ({
            (_) in
            }
        ))
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
