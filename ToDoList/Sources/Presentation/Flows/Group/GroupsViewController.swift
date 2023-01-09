//
//  GroupViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class GroupViewController: UIViewController {

    // MARK: - Properties
    public var repository: TaskRepository?
    private var data: [String] = []

    // MARK: - Visual Component
    private lazy var tableView = makeTableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        addTableView()
        fetchGroups()
    }

    private func fetchGroups() {
        repository?.fetch(id: nil, type: Tables.groups, force: false) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case.success(let data):
                guard let groups: [Group] = CoderJSON().decoderJSON(data) else { return }

                guard let model = TaskService().filterGroups(data: groups) else {
                    DispatchQueue.main.async { [weak self] in
                        self?.displayError(message: "You have no group")
                    }
                    return
                }

                self.data = model

                DispatchQueue.main.async { [weak self] in
                    self?.display()
                }
            case.failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.displayError(message: error.localizedDescription)
                }
            }
        }
    }

    private func display() {
        tableView.reloadData()
    }

    private func displayError(message: String) {
        present(makeAlertController(message), animated: true, completion: nil)
    }
}

extension GroupViewController {

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
extension GroupViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - TableView DataSource
extension GroupViewController: UITableViewDataSource {

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
extension GroupViewController {
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
