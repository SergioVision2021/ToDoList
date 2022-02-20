//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class TaskListViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var data: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }

    private func fetchData() {
        if TaskService().filterGroup().count != 0 {
            data = TaskService().filterGroup()
            configureTableView()
        } else {
            print("Not data")
        }
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        tableView.sectionFooterHeight = 0
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: InBoxViewController.Constants.taskCellIdentifier)

        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - TableView DataSource
extension TaskListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InBoxViewController.Constants.taskCellIdentifier, for: indexPath) as? TaskCell
        let group = data[indexPath.row]
        cell?.nameLabel.text = group
        return cell ?? TaskCell()
    }
}

// MARK: - TableView Delegate
extension TaskListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}
