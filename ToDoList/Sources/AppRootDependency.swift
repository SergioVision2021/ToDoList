//
//  AppRootDependency.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

protocol AppRootDependency {
    static func makeInBoxModule(service: TaskServiceLogic) -> UINavigationController
    static func makeToDayModule(service: TaskServiceLogic) -> UINavigationController
    static func makeTaskListModule(service: TaskServiceLogic) -> UINavigationController
    static func makeSearchModule(service: TaskServiceLogic) -> UINavigationController
}
