//
//  SearchViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class SearchViewController: UIViewController{
    
    let searchController: UISearchController = {
        //Для отображения результата поиска использовать текущий VC (можно указать другой)
        let search = UISearchController(searchResultsController: nil)
        //Для отображения деталей
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        return search
    }()

    var tableView = UITableView()
    let identifier = "IDCell"
    
    var data = [String]()
    var filteredData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        self.title = "Search"

        data = TaskService().filterAllTasks()
        
        createSearchController()
        createTableView()
    }
    
    func createSearchController(){
        definesPresentationContext = true
        //Подпись класса на протокол UISearchResultsUpdating
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func createTableView(){
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.sectionFooterHeight = 0
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    //Проверка строки на пустоту
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    //true - если строка активирована и не пустая
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //guard let text = searchController.searchBar.text else { return }
        //При каждом изменении - вызов фильтрации
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //Фильтрация исходных данных
    private func filterContentForSearchText(_ searchText: String) {
        filteredData = data.filter({ (name: String) -> Bool in
            return name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TableViewCell
        
        var row: String

        if isFiltering {
            row = filteredData[indexPath.row]
        } else {
            row = data[indexPath.row]
        }
        
        cell?.nameLabel.text = row
        return cell ?? TableViewCell()
    }
}
