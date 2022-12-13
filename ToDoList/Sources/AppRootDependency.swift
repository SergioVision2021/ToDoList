//
//  AppRootDependency.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

protocol AppRootDependency {
    func makeInBoxModule() -> InBoxCoordinator
    func makeToDayModule() -> UINavigationController
    func makeTaskListModule() -> UINavigationController
    func makeSearchModule() -> UINavigationController
}
