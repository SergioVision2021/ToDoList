//
//  InBoxModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation

final class InBoxModuleBuilder: ModuleBuilder {

    private let router: InBoxRouter

    init(router: InBoxRouter) {
        self.router = router
    }

    public func build() -> InBoxViewController {

        let view = InBoxViewController()
        view.title = "InBox"

        let presenter = InBoxPresenter(view: view)
        let interactor = InBoxInteractor(presenter: presenter)

        view.interactor = interactor
        view.router = router

        return view
    }
}
