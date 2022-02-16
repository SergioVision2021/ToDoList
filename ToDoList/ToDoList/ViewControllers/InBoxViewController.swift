//
//  InBoxViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class InBoxViewController: UIViewController {

    var taskService = TaskService()     //
    var data = [Group]()
    
    var tableView = UITableView()
    let identifier = "IDCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        self.title = "In Box"
        
        createBarButtonItemRight()
        
        getData(flag: "GET")
    }
    
    func getData(flag: String){
        if let d = taskService.filterPeriod(){
            data = d
            switch flag{
                case "GET": createTableView()
                case "SET": tableView.reloadData()
                default: break
            }
        }else{
            print("not data")
        }
    }
    
    func getData(_ newTask: [Group]){
        taskService.appendTask(newTask: newTask)
        getData(flag: "SET")
    }
    
    func getData(_ editTask: Task){
        taskService.editTask(editTask)
        getData(flag: "SET")
    }
    
    func createTableView(){
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.sectionFooterHeight = 0
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
    }
}

extension InBoxViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: - Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        lbl.font = UIFont.boldSystemFont(ofSize: 18.0)
        lbl.text = data[section].name
        view.addSubview(lbl)
        return view
    }

    //MARK: - Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TableViewCell
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let task = data[indexPath.section].list?[indexPath.row]
        if let n = task?.name, let s = task?.status {
            cell?.statusImageView.tintColor = s ? .systemGreen : .systemYellow
            cell?.nameLabel.text = n
        }
        return cell ?? TableViewCell()
    }
    
    //MARK: - Cell operations
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Связь му 2 VC (без segues)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "IDDetailTask") as! DetailTaskViewController
        vc.task = data[indexPath.section].list?[indexPath.row] ?? Task()             //передать данные
        vc.nameSectionTV = data[indexPath.section].name ?? ""
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension InBoxViewController: DetailTaskDelegate {
    func callback(_ editTask: Task){
        getData(editTask)
    }
}

//MARK: - Open AddTaskViewController
extension InBoxViewController{
    fileprivate func createBarButtonItemRight() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(actionBarButtonItem(sender:)))
    }
    
    @objc func actionBarButtonItem(sender: UIBarButtonItem){
        let dest = AddTaskViewController(nibName:"AddTaskViewController", bundle: nil)
        dest.delegate = self
        navigationController?.pushViewController(dest, animated: true)
    }
}

//Получить новую задачу и перезагрузить таблицу
extension InBoxViewController: AddTaskDelegate {
    func callback(_ newTask: [Group]){
        getData(newTask)
    }
}
