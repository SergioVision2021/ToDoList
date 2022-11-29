//
//  AddTaskModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class AddTaskModuleBuilder: ModuleBuilder {

    let repository: TaskRepository

    init(repository: TaskRepository) {
        self.repository = repository
    }

    func build() -> AddTaskViewController {

        let view = AppDI.makeAddTaskScene()
        view.repository = repository
        let router = AddTaskRouter(view: view)
        view.router = router

        return view
    }
}
