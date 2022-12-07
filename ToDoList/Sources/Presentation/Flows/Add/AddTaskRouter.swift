//
//  AddTaskRouter.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 21.11.22.
//

import Foundation
import UIKit

protocol AddTaskRoutingLogic {
    var coordinator: AddTaskCoordinator? { get set }
    func navigationToSelectDate(sender: AddTaskViewController)
}

class AddTaskRouter: AddTaskRoutingLogic {

    public weak var coordinator: AddTaskCoordinator?

    init(coordinator: AddTaskCoordinator) {
        self.coordinator = coordinator
    }

    public func navigationToSelectDate(sender: AddTaskViewController) {
        var vc = SelectDataModuleBuilder().build()
        vc.onSelectDate = { result in
            sender.scheduleDate = result
            sender.scheduleDateButton.setTitle(ConvertDate().convert(from: result), for: .normal)
            return
        }

        coordinator?.showSelectDateView(vc: vc)
    }
}
