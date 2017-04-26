//
//  ViewController.swift
//  IMDBsearch
//
//  Created by Anita Ilieva on 26/11/2016.
//  Copyright © 2016 Anita Ilieva. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData


class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var activityIndicator: UIActivityIndicatorView!
   
    var searchUrl = String()
    var movies = [Movie]()
    
    typealias JSONStandard = [String : AnyObject]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.isHidden = true
        self.view.addSubview(activityIndicator)
    
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.white
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            return
        }
        self.searchBar.endEditing(true)

        self.movies.removeAll()
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        var titleText = searchBar.text!
        titleText = titleText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL(string:"http://www.omdbapi.com/?y=&plot=short&tomatoes=true&r=json&page=1&s="+titleText)!
        
        let json = JSON(data: try! Data(contentsOf: url))
        
        if let error = json["Error"].string{
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: error, message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            var moviesWithImage = fetchData(json["Search"])
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {
                
                for i in 0...moviesWithImage.count-1 {
                    let imageUrl = URL(string: moviesWithImage[i].posterPath)
                    let poster = UIImage(data: try! Data(contentsOf: imageUrl!))
                    moviesWithImage[i].setMoviePoster(poster!)
                }
                self.movies.insert(contentsOf: moviesWithImage, at: 0)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                })
            })
        }
        
    }
    
    func fetchData(_ movieData: JSON) -> [Movie]{
        var moviesWithImage = [Movie]()
        
        for index in 0...movieData.count-1 {
            let title = String(describing: movieData[index]["Title"])
            let id = String(describing: movieData[index]["imdbID"])
            let year = String(describing: movieData[index]["Year"])
            let posterPath = String(describing: movieData[index]["Poster"])
            let type = String(describing: movieData[index]["Type"])
            if posterPath == "N/A" {
                
                let movie = Movie(id: id, title: title, posterPath: "", type: type, year: year)
                self.movies.append(movie)
                
            } else {
                let movie = Movie(id: id, title: title, posterPath: posterPath, type: type, year: year)
                moviesWithImage.append(movie)
            }
        }
        
        return moviesWithImage
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovie"
        {
            if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell){
                let movie = movies[indexPath.row]
                let controller = segue.destination  as! MovieDetailController
                controller.detailItem = movie
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")
        
        let movie = movies[indexPath.row]
        
        
        let imageView = cell?.viewWithTag(2) as! UIImageView
        
        let label = cell?.viewWithTag(1) as! UILabel
        
        label.text = movies[indexPath.row].title
        
        let yearLabel = cell?.viewWithTag(3) as! UILabel
        yearLabel.text = movies[indexPath.row].year
        
        if movie.posterPath == "" {
            imageView.image = UIImage(named: "no_poster")
            return cell!
        }
        imageView.image = movies[indexPath.row].mainImage
        
    return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .disclosureIndicator
                movies[indexPath.row].done = false
            } else {
                cell.accessoryType = .checkmark
                movies[indexPath.row].done = true
            }
       }

    }
}
