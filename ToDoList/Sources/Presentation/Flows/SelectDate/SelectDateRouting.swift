//
//  SelectDateRouting.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.02.2022.
//

import UIKit

protocol SelectDateRouting {
    var onSelectDate: ((Date) -> Void)? { get set }
}
