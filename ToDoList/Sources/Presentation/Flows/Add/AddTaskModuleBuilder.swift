//
//  AddTaskModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class AddTaskModuleBuilder: ModuleBuilder {

    private let router: AddTaskRouter

    init(router: AddTaskRouter) {
        self.router = router
    }

    public func build() -> AddTaskViewController {

        let view = AppDI.makeAddTaskScene()
        view.title = "Add task"
        view.router = router

        return view
    }
}
