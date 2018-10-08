//
//  SearchPresenterOutput.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

protocol SearchPresenterInput {
    func presentList(_ items: [Item])
    func presentLoadListError()
    func presentFilterList(_ list: [Item])
    func presentListFromModel()
    func presentImage(_ image: UIImage, forIndexPath: IndexPath)
}

protocol SearchPresenterOutput: class {
    func displayList(_ viewModel: SearchViewModel)
    func displayNextPageList(_ viewModel: SearchViewModel)
    func displayLoadListError()
    func displayList()
    func displayImage(_ image: UIImage, forIndexPath: IndexPath)
    func displayFilterList(_ list: [Item])
}

class SearchPresenter: SearchPresenterInput {
    weak var output: SearchPresenterOutput!
    
    // MARK: Presentation logic
    
    func presentList(_ items: [Item]) {
        let viewModel = SearchViewModel( items: items)
        output.displayList(viewModel)
    }
    
    func presentNextPageList (_ items: [Item]) {
        let viewModel = SearchViewModel( items: items)
        output.displayNextPageList(viewModel)
    }
    
    func presentLoadListError() {
        output.displayLoadListError()
    }
    
    func presentFilterList(_ list: [Item]) {
        output.displayFilterList(list)
    }
    
    func presentListFromModel() {
        output.displayList()
    }
    
    func presentImage(_ image: UIImage, forIndexPath: IndexPath) {
        output.displayImage(image, forIndexPath: forIndexPath)
    }
}
