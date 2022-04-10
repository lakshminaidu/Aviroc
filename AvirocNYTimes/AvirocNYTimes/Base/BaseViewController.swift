//
//  BaseViewController.swift
//  RikthamApp
//
//  Created by Lakshminaidu on 25/3/2022.
//

import UIKit
import Combine

class BaseViewController: UIViewController, StoryBoardManage {
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    // setup the view
    func setup() {
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemTeal
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - User defined
    /// toggle the loader
    func showloader(state: Bool) {
        if state == true {
            self.view.bringSubviewToFront(activityIndicator)
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

enum AppRouter {
    case detail(News)
    
    func controller() -> BaseViewController {
        switch self {
        case .detail(let news):
            let controller = NewsDetailController.instantiate()
            controller.seletedNews = news
            return controller
        }
    }
}
