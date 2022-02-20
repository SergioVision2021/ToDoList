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
    }

    // MARK: - IBAction
    @IBAction func selectGroupButton(_ sender: UIButton) {
        selectGroupButton.setTitle("InBox", for: .normal)               // Default - Inbox
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "IdSelectDate" else { return }
        guard let destination = segue.destination as? SelectDateViewController else { return }
        destination.delegate = self
    }

    @IBAction func saveBarButton(_ sender: UIBarButtonItem) {
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
            delegate?.callback(self, newTask)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Delegate
extension AddTaskViewController: SelectDateDelegate {
    func callback(_ sender: UIViewController, _ date: String) {
        scheduleDateButton.setTitle(date, for: .normal)
    }
}
