//
//  Movie.swift
//  IMDBsearch
//
//  Created by Anita Ilieva on 06/12/2016.
//  Copyright © 2016 Anita Ilieva. All rights reserved.
//

import Foundation
import UIKit


struct Movie {
    var id: String = ""
    var rating = ""
    var mainImage: UIImage!
    var title: String!
    var posterPath: String = ""
    var year: String = ""
    var plot = ""
    var done: Bool = false

    
    init(id: String, title: String, mainImage: UIImage) {
        self.id = id
        self.title = title
        self.mainImage = mainImage
    }
    
    init(id: String, title: String, posterPath: String, type: String, year: String) {
        self.id = id
        self.mainImage = UIImage()
        self.title = title
        self.posterPath = posterPath
        self.year = year
    }
    
    mutating func setMoviePoster(_ image: UIImage) {
        self.mainImage = image
    }
    
}
