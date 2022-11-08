//
//  DetailTaskDelegate.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.02.2022.
//

import UIKit

protocol DetailTaskDelegate {
    func detailTaskDidTapDone(_ sender: UIViewController, _ task: Task)
}
