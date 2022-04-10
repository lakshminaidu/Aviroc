//
//  AppConstants.swift
//  AvirocNYTimes
//
//  Created by Lakshminaidu on 8/4/2022.
//

import Foundation

struct AppContstants {
     static let apikey = "hJRTJaDqwclHYzKRjCxwi5WCHGITbgib"
     static let baseUrl = "https://api.nytimes.com/svc"
}

enum EndPoint: NYEndPoint {
    case mostPopular(Period)
    var url: URL? {
        switch self {
        case .mostPopular(let period):
            var urlComponents = URLComponents(string: AppContstants.baseUrl + "/mostpopular/v2/mostviewed/all-sections/\(period.rawValue).json")
            var quries = [URLQueryItem]()
            quries.append(URLQueryItem(name: "api-key", value: AppContstants.apikey))
            urlComponents?.queryItems = quries
            return urlComponents?.url
        }
    }
}

enum Period: Int {
    case daily = 1
    case weekly = 7
    case monthly = 30
}

enum AppError: Error {
    case urlError
    case networkError
    case jsonDecodingError
    case unableToFindLocation
    
    var errorMessage: String {
        switch self {
        case .urlError:
            return "Sorry for the inconvience. Will get back soon."
        case .networkError:
            return "Your internent connection is not reachable."
        case .jsonDecodingError:
             return "Sorry for the inconvience. Will get back soon."
        case .unableToFindLocation:
            return "Please enable location from settings."
        }
    }
}
