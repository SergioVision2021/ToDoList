//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var selectGroupButton: UIButton!
    @IBOutlet weak var nameTaskTF: UITextField!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var dateSchedleButton: UIButton!
    
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
    
    @objc func actionBarButtonItem(sender: UIBarButtonItem){
        //переход на предыдущий экран, сохранения таска и обновление таблицы
        
        newTask.append(Group(id: 0,
                          name: listGroup[0],
                          dateCreated: Date(),
                          list: [Task(id: 0,
                                     name: "NEW TASK",
                                     taskDeadline: nil,
                                     taskScheduledDate: Date(),
                                     notes: notesTV.text,
                                     status: false)]))
        delegate?.callback(newTask)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectGroupButton(_ sender: UIButton) {
        selectGroupButton.setTitle("InBox", for: .normal)
    }
    
    @IBAction func selectDateButton(_ sender: UIButton) {
        let dest = SelectDateViewController(nibName:"SelectDateViewController", bundle: nil)
        dest.delegate = self
        navigationController?.pushViewController(dest, animated: true)
    }
}

extension AddTaskViewController: SelectDateDelegate{
    func callback(_ date: String) {
        dateSchedleButton.setTitle(date, for: .normal)
    }
}

//Вернуть новую задачу
protocol AddTaskDelegate {
    func callback(_ newTask: [Group])
}
