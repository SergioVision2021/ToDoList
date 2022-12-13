//
//  InBoxInteractor.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 9.12.22.
//

import Foundation

enum Operations {
    case add
    case edit
    case delete
}

protocol InBoxInteractorLogic {
    func fetch()
    func execute(_ id: Int, operation: Operations)
}

class InBoxInteractor: InBoxInteractorLogic {

    private var presenter: InBoxPresenterLogic?
    private var repository = AppDI.makeTaskRepository()

    init(presenter: InBoxPresenterLogic) {
        self.presenter = presenter
    }

    public func fetch() {

        repository.fetch(id: nil, type: Tables.tasks, force: false) { [weak self] (result) in
            let response: Model.Response

            switch result {
            case.success(let data):
                guard let data: [Task] = CoderJSON().decoderJSON(data) else { return }
                response = Model.Response(tasks: data, isError: false)
            case.failure(let error):
                response = Model.Response(tasks: nil, isError: true, message: error.localizedDescription)
            }

            self?.presenter?.present(response: response)
        }
    }

    public func execute(_ id: Int, operation: Operations) {

        repository.update(type: Tables.tasks, operation, nil, id) { [weak self] error in
            let response = Model.Response(tasks: nil, isError: true, message: error?.localizedDescription)
            self?.presenter?.present(response: response)
            self?.fetch()
        }
    }
}
