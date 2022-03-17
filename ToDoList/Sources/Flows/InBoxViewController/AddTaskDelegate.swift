//
//  Protocol.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.02.2022.
//

import UIKit

protocol AddTaskDelegate {
    func addTaskDidTapSave(_ sender: UIViewController, _ task: [Group])
}
