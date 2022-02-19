//
//  SelectDateDelegate.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.02.2022.
//

import UIKit

protocol SelectDateDelegate {
    func callback(_ sender: UIViewController,_ date: String)
}
