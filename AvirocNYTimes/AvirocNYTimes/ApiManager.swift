//
//  ApiManager.swift
//  AvirocNYTimes
//
//  Created by Lakshminaidu on 8/4/2022.
//

import Foundation
import UIKit
typealias Envelope<T: Codable> = Result<T>

protocol NYEndPoint {
    var url: URL? { get }
}

enum Result <T>{
    case success(T)
    case failure(AppError)
}


protocol ApiManagerType: AnyObject {
     func request<T: Codable>(with endPoint: NYEndPoint, completion: @escaping (Envelope<T>) -> ())
}

/// Manager for handling all REST API calls
final class ApiManager: ApiManagerType {
    
    static let shared = ApiManager()
    //1 creating the session
    private let session: URLSession
    
    private init(configuration: URLSessionConfiguration) {
        configuration.timeoutIntervalForRequest = 60.00
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    //Data call with request
    
    func request<T: Codable>(with endPoint: NYEndPoint, completion: @escaping (Envelope<T>) -> ()) {
        guard let url = endPoint.url else {
            self.preserntError(error: .urlError)
            completion(.failure(.urlError))
            return
        }
        print("Service URL: \(url.absoluteString)")
        let task = self.session.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil, let httpResponse = response as? HTTPURLResponse  else {
                    self?.preserntError(error: .networkError)
                    completion(.failure(.networkError))
                    return
                }
                if httpResponse.statusCode == 200, let responsedata = data {
                    do {
                        let response = try JSONDecoder().decode(T.self, from: responsedata)
                        completion(.success(response))
                    } catch {
                        self?.preserntError(error: .jsonDecodingError)
                        completion(.failure(.jsonDecodingError))
                    }
                    
                } else {
                    self?.preserntError(error: .networkError)
                    completion(.failure(.networkError))
                }
            }
            
        }
        task.resume()
    }
    
    private func preserntError(error: AppError) {
        UIApplication.rootVC?.showAppError(error)
    }
    
}


