//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class TaskListViewController: UIViewController {

    // MARK: - Properties
    private var data: [String] = []

    // MARK: - Visual Component
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.sectionFooterHeight = 0
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: Constants.taskCellIdentifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }

    private func fetchData() {
        if InBoxViewController.shared.filterGroup().count != 0 {
            data = InBoxViewController.shared.filterGroup()
            addTableView()
        } else {
            print("Not data")
        }
    }
}

extension TaskListViewController {

    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    func configureCell(_ cell: TaskCell, _ at: IndexPath) {
        let group = data[at.row]
        cell.nameLabel.text = group
    }
}

// MARK: - TableView Delegate
extension TaskListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - TableView DataSource
extension TaskListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier, for: indexPath) as? TaskCell  else { fatalError("Unexpected Index Path") }

        configureCell(cell, indexPath)

        return cell
    }
}
