//
//  SelectDateViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class SelectDateViewController: UIViewController, SelectDateRouting {

    @IBOutlet weak var scheduleDatePicker: UIDatePicker!

    var onSelectDate: ((Date) -> Void)?

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
        onSelectDate?(scheduleDatePicker.date)
        navigationController?.popViewController(animated: true)
    }
}
