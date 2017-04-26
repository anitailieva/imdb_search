//
//  FavoriteMoviesController.swift
//  IMDBsearch
//
//  Created by Anita Ilieva on 04/12/2016.
//  Copyright © 2016 Anita Ilieva. All rights reserved.
//

import UIKit
import CoreData

class FavoriteMoviesController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var listFavoriteMovies = [NSManagedObject]()


    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
   
    func saveItem(movieTitle: String, movieYear: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovies", in: managedContext)
        
        let movieData = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        movieData.setValue(movieTitle, forKey: "title")
        movieData.setValue(movieYear, forKey: "year")
        
        
        do {
            try managedContext.save()
            listFavoriteMovies.append(movieData)
           // listFavoriteMovies.append(title)
            
        }
            
        catch{
            print("Error")
        
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "showDetail" {
            
            let detailVC: DetailViewController = segue.destination as! DetailViewController
            
            let selectedItem: NSManagedObject = listFavoriteMovies[self.tableView.indexPathForSelectedRow!.row] as NSManagedObject
                        detailVC.mainTitle = selectedItem.value(forKey: "title") as! String!
            detailVC.mainYear = selectedItem.value(forKey: "year") as! String!

            


        }
    }
    


    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovies")
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            listFavoriteMovies = results as! [NSManagedObject]
        }
            
        catch {
            print("Error")
        }
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
        

    }
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        
        managedContext.delete(listFavoriteMovies[indexPath.row])
        listFavoriteMovies.remove(at: indexPath.row)
        self.tableView.reloadData()
        
    }*/
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
            
            managedContext.delete(listFavoriteMovies[indexPath.row])
            listFavoriteMovies.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
            
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFavoriteMovies.count
        
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteMovies")! as UITableViewCell
        
        let item = listFavoriteMovies[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "title") as! String?
        cell.detailTextLabel?.text = item.value(forKey: "year") as? String

        
        return cell
        
}

}
