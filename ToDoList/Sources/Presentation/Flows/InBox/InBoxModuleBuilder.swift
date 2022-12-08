//
//  InBoxModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class InBoxModuleBuilder: ModuleBuilder {

    private let router: InBoxRouter
    private let service: TaskServiceLogic

    init(router: InBoxRouter, service: TaskServiceLogic) {
        self.router = router
        self.service = service
    }

    public func build() -> InBoxViewController {

        let view = InBoxViewController()
        view.title = "InBox"
        view.service = service
        view.router = router

        return view
    }
}
