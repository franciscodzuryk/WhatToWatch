//
//  SearchPresenterTest.swift
//  WhatToWatchTests
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import XCTest

class SearchPresenterTest: XCTestCase {
    var items = [Item]()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let path = Bundle(for: SearchInteractorTest.self).path(forResource: "Movies", ofType: "json")
        {
            do {
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchMovieResponse.self, from: json)
                items = searchResponse.results.map { return Item(itemMovieDTO:$0) }
            } catch {
                // handle error
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPresenterWithEmptyList() {
        let presenter: SearchPresenter = SearchPresenter()
        let intoutput = PresenterOutputMock()
        
        presenter.output = intoutput
        presenter.presentList(items)
        XCTAssert(intoutput.displayListVerify)
    }
    
    func testPresenterWithErrorList() {
        let presenter: SearchPresenter = SearchPresenter()
        let intoutput = PresenterOutputMock()
        
        presenter.output = intoutput
        presenter.presentLoadListError()
        XCTAssert(intoutput.displayLoadListErrorVerify)
    }
    
    func testPresenterWithFromModel() {
        let presenter: SearchPresenter = SearchPresenter()
        let intoutput = PresenterOutputMock()
        
        presenter.output = intoutput
        presenter.presentListFromModel()
        XCTAssert(intoutput.displayListFromModelVerify)
    }
    
    
    func testPresenterEmptyFilterList() {
        let presenter: SearchPresenter = SearchPresenter()
        let intoutput = PresenterOutputMock()
        
        presenter.output = intoutput
        let model: [Item] = []
        presenter.presentFilterList(model)
        
        XCTAssert(intoutput.filterResult.count == model.count)
        XCTAssert(intoutput.displayFilterListVerify)
    }
    
    func testPresenterOneFilterList() {
        let presenter: SearchPresenter = SearchPresenter()
        let intoutput = PresenterOutputMock()
        
        presenter.output = intoutput
        presenter.presentFilterList(items)
        
        XCTAssert(intoutput.filterResult.count == items.count)
        XCTAssert(intoutput.displayFilterListVerify)
    }
    
    func testPresenterTwoFilterList() {
        let presenter: SearchPresenter = SearchPresenter()
        let intoutput = PresenterOutputMock()
        
        presenter.output = intoutput
        presenter.presentFilterList(items)
        
        XCTAssert(intoutput.filterResult.count == items.count)
        XCTAssert(intoutput.displayFilterListVerify)
    }
    
    func testPresenterThreeFilterList() {
        let presenter: SearchPresenter = SearchPresenter()
        let intoutput = PresenterOutputMock()
        
        presenter.output = intoutput
        presenter.presentFilterList(items)
        
        XCTAssert(intoutput.filterResult.count == items.count)
        XCTAssert(intoutput.displayFilterListVerify)
    }
    
}

class PresenterOutputMock : SearchPresenterOutput {
    
    
    var displayListVerify: Bool         = false
    var displayLoadListErrorVerify: Bool         = false
    var displayListFromModelVerify: Bool         = false
    var displayImageVerify: Bool         = false
    var displayFilterListVerify: Bool         = false
    
    var filterResult: [Item] = []
    
    var displayListCount: Int          = 0
    var displayLoadListErrorCount: Int          = 0
    var displayListFromModelCount: Int          = 0
    var displayImageCount: Int          = 0
    var displayFilterListCount: Int          = 0
    
    func displayList(_ viewModel: SearchViewModel) {
        self.displayListVerify = true
        self.displayListCount += 1
    }
    
    func displayNextPageList(_ viewModel: SearchViewModel) {
        self.displayListVerify = true
        self.displayListCount += 1
    }
    
    func displayLoadListError() {
        self.displayLoadListErrorVerify = true
        self.displayLoadListErrorCount += 1
    }
    
    func displayList() {
        self.displayListFromModelVerify = true
        self.displayListFromModelCount += 1
    }
    
    func displayImage(_ image: UIImage, forIndexPath: IndexPath) {
        self.displayImageVerify = true
        self.displayImageCount += 1
    }
    
    func displayFilterList(_ list: [Item]) {
        self.filterResult = list
        self.displayFilterListVerify = true
        self.displayFilterListCount += 1
    }

}
