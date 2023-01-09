//
//  GroupModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class GroupModuleBuilder: ModuleBuilder {

    init() {}

    public func build() -> GroupViewController {

        let repository = AppDI.makeTaskRepository()

        let view = GroupViewController()
        view.repository = repository
        view.title = "Group"
        return view
    }
}
