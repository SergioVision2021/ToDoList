//
//  SearchViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class SearchViewController: UIViewController{
    
    //MARK: - Properties
    private var data: [String] = []
    private var filteredData: [String] = []

    //MARK: - Visual Component
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.sectionFooterHeight = 0
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: InBoxViewController.Constants.taskCellIdentifier)
        return table
    }()

    private let searchController: UISearchController = {
        //Для отображения результата поиска использовать текущий VC (можно указать другой)
        let search = UISearchController(searchResultsController: nil)
        //Для отображения деталей
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSearchController()
        fetchData()
    }
    
    private func fetchData(){
        if TaskService().filterAllTasks().count != 0 {
            data = TaskService().filterAllTasks()
            addTableView()
        } else {
            print("Not data")
        }
    }
    
    private func createSearchController(){
        definesPresentationContext = true
        //Подпись класса на протокол UISearchResultsUpdating
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func addTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

//MARK: - UISearchResultsUpdating
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

//MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

//MARK: - TableView DataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InBoxViewController.Constants.taskCellIdentifier, for: indexPath) as? TaskCell
        
        var row: String

        if isFiltering {
            row = filteredData[indexPath.row]
        } else {
            row = data[indexPath.row]
        }
        
        cell?.nameLabel.text = row
        return cell ?? TaskCell()
    }
}
