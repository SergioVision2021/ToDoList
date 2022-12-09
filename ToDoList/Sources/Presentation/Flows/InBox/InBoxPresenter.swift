//
//  InBoxPresenter.swift
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

protocol InBoxPresenterLogic {
    var repository: TaskRepository { get set }
    func fetch()
    func execute(operation: Operations, _ task: Task)
}

class InBoxPresenter: InBoxPresenterLogic {

    // MARK: - Public properties
    public var service: TaskServiceLogic
    public var repository = AppDI.makeTaskRepository()

    // MARK: - Private properties
    private weak var view: InBoxViewLogic?

    public init(view: InBoxViewLogic, service: TaskServiceLogic) {
        self.view = view
        self.service = service
    }

    public func fetch() {
        repository.fetch(force: false) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case.success(let dataModel):

                //TASK SERVICE
                self.service.source = dataModel

                self.service.fetch() { (result) in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            print(data)
                            self.view?.displayData(data: data)
                        }
                    case .failure(_):
                        break
                    }
                }
            case.failure(let error):
                self.view?.displayAlert(message: error.localizedDescription)
            }
        }
    }

    public func execute(operation: Operations, _ task: Task) {
        repository.update(operation, task) { [weak self] error in
            guard let self = self else { return }

            guard error == nil else {
                self.view?.displayAlert(message: error?.localizedDescription ?? "")
                return
            }

            self.fetch()
        }
    }
}
