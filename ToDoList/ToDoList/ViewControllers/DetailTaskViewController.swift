//
//  ViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class DetailTaskViewController: UIViewController {

    @IBOutlet weak var groupTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var scheduleDP: UIDatePicker!
    @IBOutlet weak var deadlineDP: UIDatePicker!
    
    var selectedTask = Group()
    var indexSectionTableView = Int()
    var indexRowTableView = Int()
    
    var delegate: DetailTaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        self.title = "Detail task"
        
        createBarButtonItemRight()
        getData()
    }

    func getData(){
        groupTF.text = selectedTask.name
        nameTF.text = selectedTask.list?[indexRowTableView].name
        noteTV.text = selectedTask.list?[indexRowTableView].notes
        if let dS = selectedTask.list?[indexRowTableView].taskScheduledDate{
            scheduleDP.date = dS
        }
        
        if let dD = selectedTask.list?[indexRowTableView].taskDeadline{
            deadlineDP.date = dD
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            deadlineDP.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    fileprivate func createBarButtonItemRight() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(actionBarButtonItem(sender:)))
    }
    
    @objc func actionBarButtonItem(sender: UIBarButtonItem){
            delegate?.callback(indexSectionTableView, indexRowTableView)        //Завершить задачу
            navigationController?.popViewController(animated: true)
    }
}

//Вернуть завершенную задачу
protocol DetailTaskDelegate{
    func callback(_ idGroup: Int, _ idTask: Int)
}

