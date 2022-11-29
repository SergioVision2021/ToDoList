//
//  Coordinator.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

protocol Coordinator: AnyObject {
    var tabBarController: UITabBarController { get set }
    func start()
}
