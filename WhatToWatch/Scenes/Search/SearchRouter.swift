//
//  SearchRouter.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

protocol SearchRouterInput {
    func navigateToMovieDetail(_ model: Item)
    func navigateToShowDetail(_ model: Item)
}

class SearchRouter: SearchRouterInput {
    weak var viewController: SearchVC!
    
    // MARK: Navigation
    
    func navigateToMovieDetail(_ model: Item) {
        let storyboard = UIStoryboard(name: "MovieDetailVC", bundle: nil)
        let detailViewController = storyboard.instantiateInitialViewController()! as? MovieDetailVC
        
        detailViewController!.movie = MoviesVM(item:model)
        viewController.navigationController?.pushViewController(detailViewController!, animated: true)
    }
    
    func navigateToShowDetail(_ model: Item) {
        let storyboard = UIStoryboard(name: "ShowsDetailVC", bundle: nil)
        let detailViewController = storyboard.instantiateInitialViewController()! as? ShowsDetailVC
        
        detailViewController!.show = ShowsVM(item:model)
        viewController.navigationController?.pushViewController(detailViewController!, animated: true)
    }
}
