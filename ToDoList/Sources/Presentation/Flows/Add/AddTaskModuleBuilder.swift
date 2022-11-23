//
//  AddTaskModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class AddTaskModuleBuilder: ModuleBuilder {

    let delegate: AddTaskDelegate?

    init(delegate: AddTaskDelegate?) {
        self.delegate = delegate
    }

    func build() -> AddTaskViewController {

        let view = AddTaskViewController(nibName: Constants.addTaskVCIdentifier, bundle: nil)
        view.delegate = delegate

        let router = AddTaskRouter(view: view)

        view.router = router

        return view
    }
}
