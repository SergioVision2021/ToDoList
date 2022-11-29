//
//  InBoxModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class InBoxModuleBuilder: ModuleBuilder {

    let service: TaskServiceLogic

    init(service: TaskServiceLogic) {
        self.service = service
    }

    public func build() -> InBoxViewController {

        let view = InBoxViewController()
        view.title = "InBox"
        view.service = service

        let router = InBoxRouter(view: view)

        view.router = router

        return view
    }
}
