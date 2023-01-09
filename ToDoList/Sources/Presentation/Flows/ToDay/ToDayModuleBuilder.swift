//
//  ToDayModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class ToDayModuleBuilder: ModuleBuilder {

    init() {}

    public func build() -> ToDayViewController {

        let repository = AppDI.makeTaskRepository()

        let view = ToDayViewController()
        view.repository = repository
        view.title = "ToDay"
        return view
    }
}
