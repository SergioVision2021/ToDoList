//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class AddTaskViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var selectGroupButton: UIButton!
    @IBOutlet weak var nameTaskTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var scheduleDateButton: UIButton!

    // MARK: - Properties
    private var newTask: [Group] = []
    var delegate: AddTaskDelegate?
    //private var nameGroup = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
        nameTaskTextField.text = "New task \(Int.random(in: 1..<100))"
        //addAlert()
    }

    // MARK: - IBAction
    @IBAction func selectGroupButton(_ sender: UIButton) {
        selectGroupButton.setTitle("InBox", for: .normal)               // Default - Inbox
    }
    @IBAction func selectDateButton(_ sender: UIButton) {
        let vc = SelectDateViewController(nibName: "SelectDateViewController", bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - BarButtonItem
private extension AddTaskViewController {
    func addBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(addActionButton(sender:)))
    }

    // Переход на предыдущий экран, сохранения таска и обновление таблицы
    @objc
    func addActionButton(sender: UIBarButtonItem) {
        if let text = scheduleDateButton.titleLabel?.text {
            let task = [Task(id: 0,
                            name: nameTaskTextField.text,
                            taskDeadline: nil,
                            taskScheduledDate: ConvertDate().convert(from: text),
                            notes: notesTextView.text,
                            status: false)]

            let group = Group(id: 0,
                              name: "InBox",
                              dateCreated: Date(),
                              list: task)

            newTask.append(group)

            // Возврат новой задачи
            delegate?.addTaskDidTapSave(self, newTask)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Delegate
extension AddTaskViewController: SelectDateDelegate {
    func selectDateDidTapDone(_ sender: UIViewController, _ date: String) {
        scheduleDateButton.setTitle(date, for: .normal)
    }
}

//extension AddTaskViewController {
//    func addAlert() {
//        let alert = UIAlertController(title: "Add new group",
//                                      message: "Input name new group",
//                                      preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: { _ in
//            guard let name = alert.textFields?[0].text, !name.isEmpty else {
//                return
//            }
//
//            self.nameGroup = name
//        })
//
//        alert.addAction(cancelAction)
//        alert.addAction(continueAction)
//
//        alert.addTextField { (textField) in
//            textField.placeholder = "Enter name group"
//        }
//
//        present(alert, animated: true, completion: nil)
//    }
//}
