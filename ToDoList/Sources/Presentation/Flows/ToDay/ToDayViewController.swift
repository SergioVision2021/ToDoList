//  swiftlint:disable all
//  ToDayViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class ToDayViewController: UIViewController {

    // MARK: - Private properties
    public var repository: TaskRepository?
    private var data: [Model.ViewModel.Group] = []

    // MARK: - Visual Component
    private lazy var tableView = makeTableView()
    private lazy var alertController = makeAlertController(nil)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addTableView()
        fetchTasks()
    }

    private func fetchTasks() {
        repository?.fetch(id: nil, type: Tables.tasks, force: false) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case.success(let data):
                guard let tasks: [Task] = CoderJSON().decoderJSON(data) else { return }
                guard let model = TaskService().filterPeriod(data: tasks, name: "ToDay") else {
                    DispatchQueue.main.async { [weak self] in
                        self?.displayError(message: "You have no tasks for today")
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

// MARK: - TableView
extension ToDayViewController {

    func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    func configureCell(_ cell: TaskCell, _ at: IndexPath) {
        let task = data[at.section].tasks?[at.row]
        if let name = task?.name, let status = task?.status {
            cell.statusImageView.tintColor = status ? .systemGreen : .systemYellow
            cell.nameLabel.text = name
        }
    }

    func configureSection(_ section: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        lbl.text = data[section].name
        view.addSubview(lbl)
        return view
    }
}

// MARK: - TableView DataSource
extension ToDayViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].tasks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier, for: indexPath) as? TaskCell else { fatalError("Unexpected Index Path") }

        configureCell(cell, indexPath)

        return cell
    }
}

// MARK: - TableView Delegate
extension ToDayViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return configureSection(section)
    }
}

// MARK: - Factory
extension ToDayViewController {
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
