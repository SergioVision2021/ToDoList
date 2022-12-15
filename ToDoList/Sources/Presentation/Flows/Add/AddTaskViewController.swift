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
    public var repository: TaskRepository?
    public var router: AddTaskRouter?

    public var scheduleDate: Date?
    private let numberRandom = Int.random(in: 1..<1000)

    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
        nameTaskTextField.text = "New task \(numberRandom)"
    }

    // MARK: - IBAction
    @IBAction func selectGroupButton(_ sender: UIButton) {
        selectGroupButton.setTitle("InBox", for: .normal)               // Default - Inbox
    }
    @IBAction func selectDateButton(_ sender: UIButton) {
        router?.navigationToSelectDate(sender: self)
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
        let task = Task(id: numberRandom,
                            groupId: 0,
                            name: nameTaskTextField.text,
                            taskDeadline: nil,
                            taskScheduledDate: scheduleDate,
                            notes: notesTextView.text,
                            status: false)

        repository?.update(type: Tables.tasks, .add, task, nil) { [weak self] error in
            guard let self = self else { return }

            guard error == nil else {
                DispatchQueue.main.async {
                    self.present(self.makeAlertController(error?.localizedDescription), animated: true, completion: nil)
                }
                return
            }
        }

        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Factory
private extension AddTaskViewController {
    func makeAlertController(_ message: String?) -> UIAlertController {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(button)
        return ac
    }
}
