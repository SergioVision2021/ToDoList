//
//  ToDayViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class ToDayViewController: UIViewController {
    
    //MARK: - Properties
    private var taskService = TaskService()
    private var data: [Group] = []
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
    private func fetchData() {
        if let fetchData = taskService.filterToday(namePeriod: "ToDay") {
            data = fetchData
            addTableView()
        } else {
            addAlert(title: "Warning", message: "No tasks for today!")
        }
    }

    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    private func addAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableView DataSource
extension ToDayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InBoxViewController.Constants.taskCellIdentifier, for: indexPath) as? TaskCell
        let task = data[indexPath.section].list?[indexPath.row]
        if let n = task?.name, let s = task?.status {
            cell?.statusImageView.tintColor = s ? .systemGreen : .systemYellow
            cell?.nameLabel.text = n
        }
        return cell ?? TaskCell()
    }
}

//MARK: - TableView Delegate
extension ToDayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        lbl.text = data[section].name
        view.addSubview(lbl)
        return view
    }
}
