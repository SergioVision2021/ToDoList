//
//  AppRootDependency.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

protocol AppRootDependency {
    func makeInBoxModule() -> UINavigationController
    func makeToDayModule(vc: UIViewController) -> UINavigationController
    func makeGroupModule(vc: UIViewController) -> UINavigationController
    func makeSearchModule(vc: UIViewController) -> UINavigationController
}
