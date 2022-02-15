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
    
    var task = Task()
    var nameSectionTV = String()
    var idSection = Int()

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
        groupTF.text = nameSectionTV
        nameTF.text = task.name
        noteTV.text = task.notes
        if let dS = task.taskScheduledDate{
            scheduleDP.date = dS
        }
        
        if let dD = task.taskDeadline{
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
        //Возврат номера Группы и строки выбранной задачи
        delegate?.callback(idSection, task.id ?? 0)
        navigationController?.popViewController(animated: true)
    }
}

//Вернуть завершенную задачу
protocol DetailTaskDelegate{
    func callback(_ idGroup: Int, _ idTask: Int)
}

