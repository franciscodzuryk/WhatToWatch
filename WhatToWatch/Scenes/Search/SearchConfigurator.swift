//
//  SearchConfigurator.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

extension SearchVC: SearchPresenterOutput {}

extension SearchInteractor: SearchViewControllerOutput {}

extension SearchPresenter: SearchInteractorOutput {}

class SearchConfigurator {
    
    // MARK: Object lifecycle
    
    static var sharedInstance = SearchConfigurator()
    
    fileprivate init() {}
    
    // MARK: Configuration
    
    func configure(_ viewController: SearchVC) {
        let router = SearchRouter()
        router.viewController = viewController
        
        let presenter = SearchPresenter()
        presenter.output = viewController
        
        let interactor = SearchInteractor()
        interactor.output = presenter
        interactor.worker = SearchWorker()
        
        viewController.output = interactor
        viewController.router = router
    }
}

