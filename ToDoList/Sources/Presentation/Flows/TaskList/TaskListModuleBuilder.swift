//
//  TaskListModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class TaskListModuleBuilder: ModuleBuilder {

    init() {}

    public func build() -> TaskListViewController {

        let view = TaskListViewController()
        view.title = "TaskList"
        return view
    }
}
