//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class AddTaskViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var selectGroupButton: UIButton!
    @IBOutlet weak var nameTaskTF: UITextField!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var scheduleDateButton: UIButton!
    
    //MARK: - Properties
    private var newTask = [Group]()
    public var delegate: AddTaskDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = "Add task"
        
        createBarButtonItemRight()
    }

    fileprivate func createBarButtonItemRight() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                 target: self,
                                                                 action: #selector(actionBarButtonItem(sender:)))
    }
    
    //Переход на предыдущий экран, сохранения таска и обновление таблицы
    @objc func actionBarButtonItem(sender: UIBarButtonItem){
        if let b = scheduleDateButton.titleLabel?.text{
            newTask.append(Group(id: 0,
                                 name: "InBox",                         //Default - Inbox
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
    
    //MARK: - IBAction
    @IBAction func selectGroupButton(_ sender: UIButton) {
        selectGroupButton.setTitle("InBox", for: .normal)               //Default - Inbox
    }
    
    @IBAction func selectDateButton(_ sender: UIButton) {
        let vc = SelectDateViewController(nibName:"SelectDateViewController", bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension Delegate
extension AddTaskViewController: SelectDateDelegate{
    func callback(_ date: String) {
        scheduleDateButton.setTitle(date, for: .normal)
    }
}

//MARK: - Protocol
protocol AddTaskDelegate {
    func callback(_ newTask: [Group])
}
