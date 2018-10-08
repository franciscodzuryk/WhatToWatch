//
//  MoviesDetailVCDelegate.swift
//  WhatToWatch
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

protocol ShowsDetailVCDelegate: class {
    func networkError(error:Error)
    func loadVideo(videoId:String)
    func updateImage(image:UIImage)
}
