//
//  InBoxPresenter.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 9.12.22.
//

import Foundation

protocol InBoxPresenterLogic {
    typealias Response = Model.Response
    func present(response: Response)
}

class InBoxPresenter: InBoxPresenterLogic {

    // MARK: - Private properties
    private weak var view: InBoxViewLogic?

    init(view: InBoxViewLogic) {
        self.view = view

        NotificationCenter.default.addObserver(self, selector: #selector(self.reload(notification:)), name: Notification.Name("reload"), object: nil)
    }

    public func present(response: Response) {

        guard response.isError else {
            guard let viewModel = TaskService().filter(data: response.tasks) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.view?.display(vieModel: viewModel)
            }
            return
        }

        guard let message = response.message else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.view?.displayError(message: message)
        }
    }

    @objc
    private func reload(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.fetchData()
        }
    }
}
