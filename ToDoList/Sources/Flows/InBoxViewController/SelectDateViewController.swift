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
    }

    @IBAction func doneBarButton(_ sender: UIBarButtonItem) {
        delegate?.callback(self, ConvertDate().convert(from: scheduleDatePicker.date))
        navigationController?.popViewController(animated: true)
    }
}
