//
//  InBoxViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class InBoxViewController: UIViewController {

    internal enum Constants {
        static let taskCellIdentifier = "IDCell"
    }
    
    //MARK: - Properties
    private var taskService = TaskService()     //
    private var data: [Group] = []
    
    //MARK: - Visual Component
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
        
        addBarButtonItem()
        fetchData()
        addTableView()
    }
  
    private func fetchData() {
        if let dataService = taskService.filterPeriod() {
            data = dataService
        } else {
            print("Not data")
        }
    }
    
    private func appendNewTask(_ newTask: [Group]) {
        taskService.appendTask(newTask)
        fetchData()
        tableView.reloadData()
    }
    
    private func editSelectTask(_ editTask: Task) {
        taskService.editTask(editTask)
        fetchData()
        tableView.reloadData()
    }
    
    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

//MARK: - TableView DataSource
extension InBoxViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier, for: indexPath) as? TaskCell
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let task = data[indexPath.section].list?[indexPath.row]
        if let n = task?.name,
           let s = task?.status {
            cell?.statusImageView.tintColor = s ? .systemGreen : .systemYellow
            cell?.nameLabel.text = n
        }
        return cell ?? TaskCell()
    }
}

//MARK: - TableView Delegate
extension InBoxViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        lbl.font = UIFont.boldSystemFont(ofSize: 18.0)
        lbl.text = data[section].name
        view.addSubview(lbl)
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Связь му 2 VC (без segues)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "IDDetailTask") as! DetailTaskViewController
        vc.task = data[indexPath.section].list?[indexPath.row] ?? Task()             //передать данные
        vc.nameSection = data[indexPath.section].name ?? ""
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - BarButtonItem
extension InBoxViewController {
    func addBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addActionButton(sender:)))
    }
    
    @objc
    func addActionButton(sender: UIBarButtonItem) {
        let vc = AddTaskViewController(nibName:"AddTaskViewController", bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Delegates
extension InBoxViewController: AddTaskDelegate {
    func callback(_ sender: UIViewController, _ newTask: [Group]) {
        appendNewTask(newTask)
    }
}
extension InBoxViewController: DetailTaskDelegate {
    func callback(_ sender: UIViewController, _ editTask: Task) {
        editSelectTask(editTask)
    }
}
