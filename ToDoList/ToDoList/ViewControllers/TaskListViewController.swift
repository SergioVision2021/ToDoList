//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class TaskListViewController: UIViewController {

    var taskService = TaskService()
    var data = [String]()
    
    var tableView = UITableView()
    let identifier = "IDCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        self.title = "Task List"
        
        getData()
    }
    
    func getData(){
        data = taskService.filterGroup()
        createTableView()
    }
    
    func createTableView(){
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.sectionFooterHeight = 0
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: - Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TableViewCell
        let group = data[indexPath.row]
        cell?.nameLabel.text = group
        return cell ?? TableViewCell()
    }
}
