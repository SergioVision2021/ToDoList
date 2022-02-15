//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var selectGroupButton: UIButton!
    @IBOutlet weak var nameTaskTF: UITextField!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var scheduleDateButoon: UIButton!
    
    var newTask = [Group]()
    var delegate: AddTaskDelegate?
    
    var listGroup = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        self.title = "Add task"
        
        createBarButtonItemRight()
        
        getData()
    }

    func getData(){
        listGroup = TaskService().filterGroup()
    }
    
    fileprivate func createBarButtonItemRight() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(actionBarButtonItem(sender:)))
    }
    
    //Переход на предыдущий экран, сохранения таска и обновление таблицы
    @objc func actionBarButtonItem(sender: UIBarButtonItem){
        if let b = scheduleDateButoon.titleLabel?.text{
            newTask.append(Group(id: 0,
                              name: listGroup[0],                       //Default 0 = "InBox"
                              dateCreated: Date(),
                              list: [Task(id: 0,
                                         name: nameTaskTF.text,
                                         taskDeadline: nil,
                                          taskScheduledDate: ConvertDate().convert(from: b),
                                         notes: notesTV.text,
                                         status: false)]))
            delegate?.callback(newTask)
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Action
    @IBAction func selectGroupButton(_ sender: UIButton) {
        selectGroupButton.setTitle(listGroup[0], for: .normal)      //Default 0 = "InBox"
    }
    
    @IBAction func selectDateButton(_ sender: UIButton) {
        let dest = SelectDateViewController(nibName:"SelectDateViewController", bundle: nil)
        dest.delegate = self
        navigationController?.pushViewController(dest, animated: true)
    }
}

extension AddTaskViewController: SelectDateDelegate{
    func callback(_ date: String) {
        scheduleDateButoon.setTitle(date, for: .normal)
    }
}

//Вернуть новую задачу
protocol AddTaskDelegate {
    func callback(_ newTask: [Group])
}
