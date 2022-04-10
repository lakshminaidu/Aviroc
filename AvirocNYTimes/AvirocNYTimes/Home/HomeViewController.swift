//
//  HomeViewController.swift
//  AvirocNYTimes
//
//  Created by Lakshminaidu on 8/4/2022.
//

import Foundation
import UIKit
import Combine

class HomeViewController: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var newstable: UITableView!
    @IBOutlet weak var periodSegemnt: UISegmentedControl!
    //MARK: - varibales
    var searchBar: UISearchBar = UISearchBar()
    var viewModel: HomeViewModelType = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
         fetchData()
    }
    
    override func setup() {
        super.setup()
        newstable.delegate = self
        newstable.dataSource = self
        self.title = "Most Popular"
        self.navigationController?.updateBarColor(color: .systemTeal)
        prepareSearchBar()
    }
    
    // MARK: - IBactions
    
    @IBAction func periodSegemntChanged(_ sender: UISegmentedControl) {
        var period = Period.daily
        searchBar.text = ""
        searchBar.resignFirstResponder()
        switch sender.selectedSegmentIndex {
        case 0: period = .daily
        case 1: period = .weekly
        case 2: period = .monthly
        default: break
        }
        fetchData(period: period)
    }
    
    // MARK: - Methods
    private func prepareSearchBar() {
        searchBar.sizeToFit()
        newstable.tableHeaderView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search here.."
    }
    
    private func fetchData(period: Period = .weekly)  {
        self.showloader(state: true)
        viewModel.dataPublisher.receive(on: DispatchQueue.main).sink {[weak self] news in
            guard news != nil else {return}
            self?.showloader(state: false)
            self?.newstable.reloadData()
        }.store(in: &cancellables)
        viewModel.fetchNews(period: period)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.newsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.className, for: indexPath) as? NewsCell {
            cell.data = viewModel.newsData?[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let data = viewModel.newsData?[indexPath.row] else { return }
        let controller = AppRouter.detail(data).controller()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateResults(query: searchText)
    }
}
