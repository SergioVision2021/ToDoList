//
//  AddTaskModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class AddTaskModuleBuilder: ModuleBuilder {

    private let router: AddTaskRouter
    private let repository: TaskRepository

    init(router: AddTaskRouter, repository: TaskRepository) {
        self.router = router
        self.repository = repository
    }

    public func build() -> AddTaskViewController {

        let view = AppDI.makeAddTaskScene()
        view.title = "Add task"
        view.repository = repository
        view.router = router

        return view
    }
}
