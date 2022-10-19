//
//  SelectDateViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class SelectDateViewController: UIViewController {

    @IBOutlet weak var scheduleDatePicker: UIDatePicker!

    internal var delegate: SelectDateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButtonItem()
    }
}

private extension SelectDateViewController {
    func addBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(addActionButton(sender:)))
    }

    @objc
    func addActionButton(sender: UIBarButtonItem) {
        // Вернуть выбранную дату
        delegate?.selectDateDidTapDone(self, scheduleDatePicker.date)
        navigationController?.popViewController(animated: true)
    }
}
