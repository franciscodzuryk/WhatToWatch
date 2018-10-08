//
//  SearchInteractorTest.swift
//  WhatToWatchTests
//
//  Created by Fran on 06/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import XCTest

class SearchInteractorTest: XCTestCase {
    var worker: InteractorWorker!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        worker = InteractorWorker()
        if let path = Bundle(for: SearchInteractorTest.self).path(forResource: "Movies", ofType: "json")
        {
            do {
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchMovieResponse.self, from: json)
                worker.items = searchResponse.results.map { return Item(itemMovieDTO:$0) }
            } catch {
                // handle error
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testInteractorWithEmptyList() {
        
        let interactor: SearchInteractor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        interactor.loadMovieList(SearchRequest(""))
        XCTAssert(intoutput.presentListVerify)
    }
    
    func testInteractorWithErrorList() {
        
        let interactor: SearchInteractor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        interactor.output = intoutput
        worker.callSuccess = false
        interactor.worker = worker
        interactor.loadMovieList(SearchRequest(""))
        XCTAssert(intoutput.presentLoadListErrorVerify)
    }
    
    func testInteractorWithFullList() {
        
        let interactor: SearchInteractor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        
        interactor.loadMovieList(SearchRequest(""))
        XCTAssert(intoutput.presentListVerify)
    }
    
    func testSearchWithEmptyTextList() {
        
        let interactor: SearchInteractor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        
        let model: SearchViewModel = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "")
        XCTAssert(intoutput.filterResult.isEmpty)
        XCTAssert(intoutput.presentListFromModelVerify)
    }
    
    func testSearchWithShortTextList() {
        
        let interactor: SearchInteractor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        let model = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "ab")
        
        XCTAssert(intoutput.filterResult.isEmpty)
        XCTAssert(intoutput.presentListFromModelVerify)
    }
    
    func testSearchWithOneResultList() {
        
        let interactor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        let model = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "Homec")
        
        XCTAssert(intoutput.filterResult.count == 1)
        XCTAssert(intoutput.presentFilterListVerify)
    }
    
    func testSearchWithTwoResultList() {
        
        let interactor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        let model = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "Home")
        
        XCTAssert(intoutput.filterResult.count == 2)
        XCTAssert(intoutput.presentFilterListVerify)
    }
    
    func testSearchWithoutResultList() {
        
        let interactor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        let model = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "arw")
        
        XCTAssert(intoutput.filterResult.isEmpty)
        XCTAssert(intoutput.presentFilterListVerify)
    }
    
    func testSearchWithTreeWhiteSpaceResultList() {
        
        let interactor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        
        let model = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "   ")
        
        XCTAssert(intoutput.filterResult.isEmpty)
        XCTAssert(intoutput.presentListFromModelVerify)
    }
    
    func testSearchWithLeadingSpacesAndOneResult() {
        
        let interactor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        let model = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "   homec")
        
        XCTAssert(intoutput.filterResult.count == 1)
        XCTAssert(intoutput.presentFilterListVerify)
    }
    
    func testSearchWithLeadingSpacesAndTwoResult() {
        
        let interactor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        
        let model = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "   home")
        
        XCTAssert(intoutput.filterResult.count == 2)
        XCTAssert(intoutput.presentFilterListVerify)
    }
    
    func testSearchWithEndingSpacesAndOneResult() {
        
        let interactor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        let model = SearchViewModel(items: worker.items)
        interactor.filterList(model, searhText: "homec   ")
        
        XCTAssert(intoutput.filterResult.count == 1)
        XCTAssert(intoutput.presentFilterListVerify)
    }
    
    func testSearchWithLeadingAndEndingSpacesAndOneResult() {
        
        let interactor = SearchInteractor()
        let intoutput = InteractorOutputMock()
        
        interactor.output = intoutput
        worker.callSuccess = true
        interactor.worker = worker
        let model = SearchViewModel(items: worker.items)
        
        interactor.filterList(model, searhText: "   homec   ")
        
        XCTAssert(intoutput.filterResult.count == 1)
        XCTAssert(intoutput.presentFilterListVerify)
    }
}

class InteractorWorker: SearchWorkerProtocol {
    var callSuccess: Bool = false
    var items: [Item] = []
    var searchMovieResponse: SearchMovieResponse!
    var searchShowResponse: SearchShowResponse!
    init() {
        if let path = Bundle(for: SearchInteractorTest.self).path(forResource: "Movies", ofType: "json")
        {
            do {
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                searchMovieResponse = try decoder.decode(SearchMovieResponse.self, from: json)
            } catch {
                // handle error
            }
        }
        
        if let path = Bundle(for: SearchInteractorTest.self).path(forResource: "Shows", ofType: "json")
        {
            do {
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                searchShowResponse = try decoder.decode(SearchShowResponse.self, from: json)
            } catch {
                // handle error
            }
        }
    }
    
    func getMovieList(_ query: MoviesSearchParameters, success: @escaping ([Item]) -> Void, fail: @escaping (Error) -> Void) {
        if callSuccess {
            let items = searchMovieResponse.results.map { return Item(itemMovieDTO:$0) }
            success(items)
        } else {
            fail(NSError(domain:"", code:4, userInfo:nil))
        }
    }
    
    func getLocalMovieList(_ success: @escaping ([Item]) -> Void, fail: @escaping (Error) -> Void) {
        if callSuccess {
            let items = searchMovieResponse.results.map { return Item(itemMovieDTO:$0) }
            success(items)
        } else {
            fail(NSError(domain:"", code:4, userInfo:nil))
        }
    }
    
    func getShowList(_ query: MoviesSearchParameters, success: @escaping ([Item]) -> Void, fail: @escaping (Error) -> Void) {
        if callSuccess {
            let items = searchShowResponse.results.map { return Item(itemShowDTO:$0) }
            success(items)
        } else {
            fail(NSError(domain:"", code:4, userInfo:nil))
        }
    }
    
    func getLocalShowList(_ success: @escaping ([Item]) -> Void, fail: @escaping (Error) -> Void) {
        if callSuccess {
            let items = searchShowResponse.results.map { return Item(itemShowDTO:$0) }
            success(items)
        } else {
            fail(NSError(domain:"", code:4, userInfo:nil))
        }
    }
    
    func getImage(_ url: String, success: @escaping (UIImage) -> Void, fail: @escaping (NSError) -> Void) {
        
    }
    
}

class InteractorOutputMock: SearchInteractorOutput {
    
    var presentListVerify: Bool         = false
    var presentLoadListErrorVerify: Bool = false
    var presentFilterListVerify: Bool   = false
    var presentListFromModelVerify: Bool = false
    var presentImageVerify: Bool = false
    
    var filterResult: [Item] = []
    
    
    var presentListCount: Int          = 0
    var presentLoadListErrorCount: Int = 0
    var presentFilterListCount: Int    = 0
    var presentListFromModelCount: Int = 0
    var presentImageCount: Int = 0
    
    func presentList(_ response: SearchMovieResponse) {
        self.presentListVerify = true
        self.presentListCount += 1
    }
    
    func presentList(_ items: [Item]) {
        self.presentListVerify = true
        self.presentListCount += 1
    }
    
    func presentNextPageList(_ items: [Item]) {
        self.presentListVerify = true
        self.presentListCount += 1
    }
    
    func presentLoadListError() {
        self.presentLoadListErrorVerify = true
        self.presentLoadListErrorCount += 1
    }
    
    func presentFilterList(_ list: [Item]) {
        self.filterResult = list
        self.presentFilterListVerify = true
        self.presentFilterListCount += 1
    }
    
    func presentListFromModel() {
        self.presentListFromModelVerify = true
        self.presentListFromModelCount += 1
    }
    
    func presentImage(_ image: UIImage, forIndexPath: IndexPath) {
        self.presentImageVerify = true
        self.presentImageCount += 1
    }


}
