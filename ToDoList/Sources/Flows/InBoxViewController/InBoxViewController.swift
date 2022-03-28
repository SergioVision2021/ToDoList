//
//  InBoxViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class InBoxViewController: UIViewController {

    // MARK: - Properties
    var service: TaskServiceProtocol?
    private var data: [Group] = []

    // MARK: - Visual Component
    private lazy var tableView = makeTableView()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
        fetchData()
        addTableView()
    }

    private func fetchData() {
        guard let fetchData = service?.filterPeriod() else {
            print("Not data")
            return
        }

        data = fetchData
    }

    private func add(_ task: [Group]) {
        service?.add(task)
        fetchData()
        tableView.reloadData()
    }

    private func edit(_ task: Task, _ status: Bool) {
        service?.edit(task, status)
        fetchData()
        tableView.reloadData()
    }
}

// MARK: - TableView
extension InBoxViewController {

    func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    func configureCell(_ cell: TaskCell, _ at: IndexPath) {
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let task = data[at.section].list?[at.row]
        if let name = task?.name,
           let status = task?.status {
            cell.statusImageView.tintColor = status ? .systemGreen : .systemYellow
            cell.nameLabel.text = name
        }
    }

    func configureSection(_ section: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        lbl.font = UIFont.boldSystemFont(ofSize: 18.0)
        lbl.text = data[section].name
        view.addSubview(lbl)
        return view
    }

    func configureViewController(_ vc: DetailTaskViewController, _ at: IndexPath) {
        vc.task = data[at.section].list?[at.row] ?? Task()
        vc.nameSection = data[at.section].name ?? ""
        vc.delegate = self
        show(vc, sender: self)
    }
}

// MARK: - TableView DataSource
extension InBoxViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier, for: indexPath) as? TaskCell else { fatalError("Unexpected Index Path") }

        configureCell(cell, indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()

            guard let selectTask = data[indexPath.section].list?[indexPath.row] else { return }
            edit(selectTask, true)

            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

// MARK: - TableView Delegate
extension InBoxViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return configureSection(section)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Связь му 2 VC (без segues)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        guard let vc = storyBoard.instantiateViewController(withIdentifier: "IdDetailTask") as? DetailTaskViewController else { fatalError("Unexpected Index Path") }

        configureViewController(vc, indexPath)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

// MARK: - BarButtonItem
extension InBoxViewController {
    func addBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addActionButton(sender:)))
    }

    @objc
    func addActionButton(sender: UIBarButtonItem) {
        let vc = AddTaskViewController(nibName: "AddTaskViewController", bundle: nil)
        vc.delegate = self

        show(vc, sender: self)
    }
}

// MARK: - Delegates
extension InBoxViewController: AddTaskDelegate {
    func addTaskDidTapSave(_ sender: UIViewController, _ task: [Group]) {
        add(task)
    }
}
extension InBoxViewController: DetailTaskDelegate {
    func detailTaskDidTapDone(_ sender: UIViewController, _ task: Task) {
        edit(task, false)
    }
}

// MARK: - Factory
extension InBoxViewController {
    func makeTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        table.sectionFooterHeight = 0

        let nib = UINib(nibName: "TaskCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: Constants.taskCellIdentifier)

        return table
    }
}
