//
//  HomeViewModel.swift
//  AvirocNYTimes
//
//  Created by Lakshminaidu on 8/4/2022.
//

import Foundation
import Combine

protocol HomeViewModelType {
    var apiMangaer: ApiManagerType {get}
    var dataPublisher: Published<[News]?>.Publisher { get }
    var newsData: [News]? {get}
    func fetchNews(period: Period)
    func updateResults(query: String)
}

class HomeViewModel: HomeViewModelType {
    
    private var dataCopy: [News]?
    var apiMangaer: ApiManagerType
    @Published var newsData: [News]?
    var dataPublisher: Published<[News]?>.Publisher { $newsData }
    
    init(apimanager: ApiManagerType = ApiManager.shared) {
        self.apiMangaer = apimanager
    }
    
    func fetchNews(period: Period) {
        let endpoint = EndPoint.mostPopular(period)
        apiMangaer.request(with: endpoint) {[weak self] (result: Envelope<ResponseModel>) in
            switch result {
            case .success(let res):
                self?.newsData = res.results ?? []
                self?.dataCopy = res.results ?? []
            case.failure:
                self?.newsData = []
                self?.dataCopy = []
            }
        }
    }
    
    func updateResults(query: String) {
        print(query)
        guard !query.isEmpty else {
            newsData = dataCopy
            return
        }
        newsData = dataCopy?.filter({$0.title?.range(of: query, options: .caseInsensitive) != nil})
    }

}
