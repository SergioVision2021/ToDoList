//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var dateSchedleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        self.title = "Add task"
        
        createBarButtonItemRight()
    }

    fileprivate func createBarButtonItemRight() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(actionBarButtonItem(sender:)))
    }
    
    @objc func actionBarButtonItem(sender: UIBarButtonItem){
        //переход на предыдущий экран, сохранения таска и обновление таблицы
    }

    @IBAction func selectDateButton(_ sender: UIButton) {
        let dest = SelectDateViewController(nibName:"SelectDateViewController", bundle: nil)
        dest.delegate = self
        navigationController?.pushViewController(dest, animated: true)
    }
}

extension AddTaskViewController: SelectDateDelegate{
    func callback(_ date: String) {
        dateSchedleButton.setTitle(date, for: .normal)
    }
}
