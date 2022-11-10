//
//  InBoxModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class InBoxModuleBuilder: ModuleBuilder {

    let service: TaskService

    init(service: TaskService) {
        self.service = service
    }

    public func build() -> InBoxViewController {

        let view = InBoxViewController()
        view.title = "InBox"
        view.service = service
        return view
    }
}
