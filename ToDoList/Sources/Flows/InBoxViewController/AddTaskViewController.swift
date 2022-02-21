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
    internal var delegate: AddTaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
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
