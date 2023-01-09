//  swiftlint:disable all
//  ModuleBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 10.11.22.
//

import Foundation
import UIKit

protocol ViewProtocol: UIViewController {}

// Basic builder represents for building module
public protocol ModuleBuilder {
    associatedtype ViewController

    // Returns instance of UIViewController
    func build() -> ViewController
}
