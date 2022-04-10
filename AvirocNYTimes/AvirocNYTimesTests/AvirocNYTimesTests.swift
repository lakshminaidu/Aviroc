//
//  AvirocNYTimesTests.swift
//  AvirocNYTimesTests
//
//  Created by Lakshminaidu on 9/4/2022.
//

import XCTest
@testable import AvirocNYTimes
import Combine

class AvirocNYTimesTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testResponseModel() {
        let model = ResponseModel.testModel
        XCTAssertTrue(model.results?.count == 3)
        XCTAssertTrue(model.status == "OK")
    }
    
    func testHomeViewModel() {
        let model = HomeViewModel()
        XCTAssertTrue(model.newsData == nil)
        model.dataCopy = ResponseModel.testModel.results
        model.newsData = ResponseModel.testModel.results
        XCTAssertTrue(model.newsData?.count == 3)
        
    }
    
    func test_serach_HomeViewModel() {
        let model = HomeViewModel(apimanager: MockApiManager.shared)
        XCTAssertTrue(model.newsData == nil)
        let promise = expectation(description: "NewsAPI")
        model.fetchNews(period: .weekly)
        promise.fulfill()
        wait(for: [promise], timeout: 5)
        
        XCTAssertEqual(model.newsData?.count, 3, "Didn't parse mock data")
        
        model.updateResults(query: "Marjorie")
        XCTAssertTrue(model.newsData?.count == 1)
        model.updateResults(query: "")
        XCTAssertTrue(model.newsData?.count == 3)
        
    }
    
    func testEndPont_daily() {
        let endPont = EndPoint.mostPopular(.daily)
        if let url = endPont.url?.absoluteString {
            XCTAssertTrue(url.contains("1.json?"))
        }
    }
    func testEndPont_weekly() {
        let endPont = EndPoint.mostPopular(.weekly)
        if let url = endPont.url?.absoluteString {
            XCTAssertTrue(url.contains("7.json?"))
        }
    }
    
    func testEndPont_monthly() {
        let endPont = EndPoint.mostPopular(.monthly)
        if let url = endPont.url?.absoluteString {
            XCTAssertTrue(url.contains("30.json?"))
        }
    }
    
    func testdetail() {
        let detial = NewsDetailController.instantiate()
        detial.seletedNews = ResponseModel.testModel.results?.first
        
        XCTAssertNotNil(detial.seletedNews)
        detial.viewDidLoad()
        XCTAssertNotNil(detial.titleLabel.text)

    }
    
    func testHomeScrenn() {
        let home = HomeViewController.instantiate()
        let promise = expectation(description: "NewsAPI")
        home.viewModel = HomeViewModel(apimanager: MockApiManager.shared)
        home.viewDidLoad()
        promise.fulfill()
        wait(for: [promise], timeout: 5)
       
        XCTAssertNotNil(home.viewModel)
        XCTAssertNotNil(home.newstable.delegate)
        XCTAssertNotNil(home.newstable.dataSource)
        XCTAssertEqual(3, home.tableView(home.newstable, numberOfRowsInSection: 0))
        XCTAssertTrue(home.tableView(home.newstable, cellForRowAt: IndexPath(row: 0, section: 0)) is NewsCell)


    }
    
}


extension ResponseModel {
    static let testModel: Self = MockApiManager.load("Mock.json")
}


final class MockApiManager: ApiManagerType {
    static let shared = MockApiManager()
    func request<T>(with endPoint: NYEndPoint, completion: @escaping (Envelope<T>) -> ()) where T : Decodable, T : Encodable {
        completion(.success(ResponseModel.testModel as! T))
    }
    
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        guard let file = Bundle(for: AvirocNYTimesTests.self).url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            data = try Data(contentsOf: file)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
    }
}
