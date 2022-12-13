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
    private var repository = AppDI.makeTaskRepository()

    // MARK: - Visual Component
    private lazy var tableView = makeTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        addTableView()
        fetch()
    }

    private func fetch() {
        repository.fetch(id: nil, type: Tables.groups, force: false) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case.success(let data):
                guard let groups: [Group] = CoderJSON().decoderJSON(data) else { return }

                guard let model = TaskService().filterGroups(data: groups) else {
                    self.displayAlert(message: "You have no group")
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
            self?.tableView.reloadData()
        }
    }

    private func displayAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(self.makeAlertController(message), animated: true, completion: nil)
        }
    }
}

extension TaskListViewController {

    func addTableView() {
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

// MARK: - Factory
extension TaskListViewController {
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
