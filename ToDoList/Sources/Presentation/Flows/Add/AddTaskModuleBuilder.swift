//
//  AddTaskModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class AddTaskModuleBuilder {

    func build(delegate: AddTaskDelegate?) -> AddTaskViewController {

        let view = AddTaskViewController(nibName: Constants.addTaskVCIdentifier, bundle: nil)
        view.delegate = delegate
        return view
    }
}
