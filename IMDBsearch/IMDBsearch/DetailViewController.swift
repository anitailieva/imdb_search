//
//  DetailViewController.swift
//  IMDBsearch
//
//  Created by Anita Ilieva on 05/12/2016.
//  Copyright © 2016 Anita Ilieva. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var mainTitle = String()
    var mainYear = String()
    var mainRuntime = String()
    var mainReleased = String()
    var mainPlot = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = mainTitle
        yearLbl.text =  "Year: " + mainYear
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
