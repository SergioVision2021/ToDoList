//
//  AppRootDependency.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

protocol AppRootDependency {
    func makeTaskService() -> TaskServiceLogic
    func makeInBoxModule(coordinator: InBoxCoordinator) -> UINavigationController
    func makeToDayModule(service: TaskServiceLogic) -> UINavigationController
    func makeTaskListModule(service: TaskServiceLogic) -> UINavigationController
    func makeSearchModule(service: TaskServiceLogic) -> UINavigationController
}
