//
//  MoviesVCDelegate.swift
//  WhatToWatch
//
//  Created by Fran on 03/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

protocol MoviesVCDelegate: AnyObject {
    func networkError(error:Error)
    func updateMovies(movies: [MoviesVM])
    func updateImage(image:UIImage, indexPath: IndexPath)
}
