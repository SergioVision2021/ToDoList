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
    public var id: Int?
    private var repository: TaskRepository = AppDI.makeTaskRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
        fetch()
    }

    private func fetch() {

        repository.fetch(id: id, type: Tables.tasks, force: false) { [weak self] result in
            switch result {
            case.success(let data):

                guard let data: [Task] = CoderJSON().decoderJSON(data) else { return }

                self?.configureUI(data: data.first)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func configureUI(data: Task?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            guard let group = data?.groupId else { return }
            self.groupTexField.text = String(group)
            self.nameTextField.text = data?.name
            self.noteTextView.text = data?.notes

            if let dateS = data?.taskScheduledDate {
                self.scheduleDatePicker.date = dateS
            }

            if let dateD = data?.taskDeadline {
                self.deadlineDatePicker.date = dateD
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                self.deadlineDatePicker.isHidden = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }

    private func getData() -> Task {
        var task = Task(id: id,
                        groupId: Int(groupTexField.text ?? "") ?? 0,
                        name: nameTextField.text,
                        taskScheduledDate: scheduleDatePicker.date, notes: noteTextView.text)

        task.setDeadlineTask()
        return task
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

        repository.update(type: .tasks, .edit, getData(), nil) { [weak self] error in
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
private extension DetailTaskViewController {
    func makeAlertController(_ message: String?) -> UIAlertController {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(button)
        return ac
    }
}
