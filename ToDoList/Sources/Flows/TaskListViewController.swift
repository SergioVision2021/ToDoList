//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class TaskListViewController: UIViewController {

    //MARK: - Properties
    private var data: [String] = []
    
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
        if TaskService().filterGroup().count != 0 {
            data = TaskService().filterGroup()
            addTableView()
        } else {
            print("Not data")
        }
    }
    
    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InBoxViewController.Constants.taskCellIdentifier, for: indexPath) as? TaskCell
        let group = data[indexPath.row]
        cell?.nameLabel.text = group
        return cell ?? TaskCell()
    }
}
