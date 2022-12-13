//
//  SearchViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    private var data: [String] = []
    private var filteredData: [String] = []
    private var repository = AppDI.makeTaskRepository()

    // MARK: - Visual Component
    private lazy var tableView = makeTableView()

    private let searchController: UISearchController = {
        // Для отображения результата поиска использовать текущий VC (можно указать другой)
        let search = UISearchController(searchResultsController: nil)
        // Для отображения деталей
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addTableView()
        fetch()
    }

    private func fetch() {
        repository.fetch(id: nil, type: Tables.tasks, force: false) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case.success(let data):
                guard let tasks: [Task] = CoderJSON().decoderJSON(data) else { return }

                guard let model = TaskService().filterTasks(data: tasks) else {
                    self.displayAlert(message: "You have no tasks")
                    return
                }

                self.data = model
                self.display()
            case.failure(let error): break
            }
        }
    }

    private func display() {
        DispatchQueue.main.async { [weak self] in
            self?.createSearchController()
            self?.tableView.reloadData()
        }
    }

    private func displayAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(self.makeAlertController(message), animated: true, completion: nil)
        }
    }

    private func createSearchController() {
        definesPresentationContext = true
        // Подпись класса на протокол UISearchResultsUpdating
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

// MARK: - TableView
extension SearchViewController {

    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    func configureCell(_ cell: TaskCell, _ at: IndexPath) {
        var row: String

        if isFiltering {
            row = filteredData[at.row]
        } else {
            row = data[at.row]
        }

        cell.nameLabel.text = row
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    // Проверка строки на пустоту
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    // true - если строка активирована и не пустая
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    func updateSearchResults(for searchController: UISearchController) {
        // guard let text = searchController.searchBar.text else { return }
        // При каждом изменении - вызов фильтрации
        filterContentForSearchText(searchController.searchBar.text!)
    }

    // Фильтрация исходных данных
    private func filterContentForSearchText(_ searchText: String) {
        filteredData = data.filter({ (name: String) -> Bool in
            return name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - TableView DataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier, for: indexPath) as? TaskCell  else { fatalError("Unexpected Index Path") }

        configureCell(cell, indexPath)

        return cell
    }
}

// MARK: - Factory
extension SearchViewController {
    func makeTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.sectionFooterHeight = 0

        let nib = UINib(nibName: "TaskCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: Constants.taskCellIdentifier)

        return table
    }
    
    func makeAlertController(_ message: String?) -> UIAlertController {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(button)
        return ac
    }
}
