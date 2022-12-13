//
//  InBoxCoordinator.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 6.12.22.
//

import Foundation
import UIKit

class InBoxCoordinator: Coordinator {

    public let navigationController: UINavigationController
    public weak var parentCoordinator: AppCoordinatorImpl?

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    public func start() {
        let vc = InBoxModuleBuilder(router: self).build()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension InBoxCoordinator: InBoxRouter {

    func navigationToAddTask() {
        let vc = AddTaskModuleBuilder(router: self).build()
        navigationController.pushViewController(vc, animated: true)
    }

    func navigationToDetailTask(id: Int, sender: InBoxViewController) {
        let vc = DetailTaskModuleBuilder(id: id).build()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension InBoxCoordinator: AddTaskRouter {

    func navigationToSelectDate(sender: AddTaskViewController) {
        var vc = SelectDataModuleBuilder().build()

        vc.onSelectDate = { result in
            sender.scheduleDate = result
            sender.scheduleDateButton.setTitle(ConvertDate().convert(from: result), for: .normal)
            return
        }

        navigationController.pushViewController(vc, animated: true)
    }
}
