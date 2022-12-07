//
//  AddTaskModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class AddTaskModuleBuilder: ModuleBuilder {

    private let coordinator: AddTaskCoordinator
    private let repository: TaskRepository

    init(coordinator: AddTaskCoordinator, repository: TaskRepository) {
        self.coordinator = coordinator
        self.repository = repository
    }

    public func build() -> AddTaskViewController {

        let view = AppDI.makeAddTaskScene()
        view.title = "Add task"
        view.repository = repository

        let router = AddTaskRouter(coordinator: coordinator)
        view.router = router

        return view
    }
}
