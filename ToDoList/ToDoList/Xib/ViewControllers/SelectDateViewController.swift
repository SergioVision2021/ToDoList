//
//  SelectDateViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class SelectDateViewController: UIViewController {

    @IBOutlet weak var schedulePD: UIDatePicker!
    
    var delegate: SelectDateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        self.title = "Select date"
        
        createBarButtonItemRight()
    }
    
    fileprivate func createBarButtonItemRight() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(actionBarButtonItem(sender:)))
    }
    
    @objc func actionBarButtonItem(sender: UIBarButtonItem){
        delegate?.callback(ConvertDate().convert(date: schedulePD.date))
        navigationController?.popViewController(animated: true)
    }
}

protocol SelectDateDelegate {
    func callback(_ date: String)
}
