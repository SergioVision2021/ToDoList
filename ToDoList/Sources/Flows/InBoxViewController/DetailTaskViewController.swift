//
//  ViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class DetailTaskViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var groupTexField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var scheduleDatePicker: UIDatePicker!
    @IBOutlet weak var deadlineDatePicker: UIDatePicker!

    // MARK: - Properties
    internal var task = Task()
    internal var nameSection = String()
    internal var delegate: DetailTaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
        getData()
    }

    private func getData() {
        groupTexField.text = nameSection
        nameTextField.text = task.name
        noteTextView.text = task.notes

        if let dateS = task.taskScheduledDate {
            scheduleDatePicker.date = dateS
        }

        if let dateD = task.taskDeadline {
            deadlineDatePicker.date = dateD
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            deadlineDatePicker.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

// MARK: - BarButtonItem
private extension DetailTaskViewController {
    func addBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(addActionButton(sender:)))
    }

    @objc
    func addActionButton(sender: UIBarButtonItem) {
        task.setDeadlineTask()

        // Вернуть завершенную задачу
        delegate?.detailTaskDidTapDone(self, task)
        navigationController?.popViewController(animated: true)
    }
}
