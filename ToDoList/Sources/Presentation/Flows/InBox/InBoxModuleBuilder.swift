//
//  InBoxModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class InBoxModuleBuilder: ModuleBuilder {

    private let coordinator: InBoxCoordinator
    private let service: TaskServiceLogic

    init(coordinator: InBoxCoordinator, service: TaskServiceLogic) {
        self.coordinator = coordinator
        self.service = service
    }

    public func build() -> InBoxViewController {

        let view = InBoxViewController()
        view.title = "InBox"
        view.service = service

        let router = InBoxRouter(coordinator: coordinator)
        view.router = router

        return view
    }
}
