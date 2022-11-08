//
//  DetailTaskBuilder.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation
import UIKit

final class DetailTaskModuleBuilder {

    func build(task: Task, nameSection: String, delegate: DetailTaskDelegate?) -> DetailTaskViewController {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyBoard.instantiateViewController(withIdentifier: Constants.detailTaskVCIdentifier) as? DetailTaskViewController else {
            fatalError("Unexpected Index Path")
        }
        view.task = task
        view.nameSection = nameSection
        view.delegate = delegate

        return view
    }
}
