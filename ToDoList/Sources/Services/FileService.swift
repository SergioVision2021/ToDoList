//swiftlint:disable all
//  MemoryService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

// JSON

class FileService: TaskService {

    var storage = StorageHelper<Group>(folderName: "ToDoList", fileName: "Data")

    override init() {
        super.init()

        guard let group : [Group] = storage.getData() else {
            print("Group empty")
            saveDefaultData()
            print("Save default data")
            return
        }

        source = group
    }

    private func saveDefaultData() {
        super.defaultGroup()
        storage.saveJsonToFile(source)
    }

//    override func add(_ task: Task) {
//        super.add(task)
//        storage.saveJsonToFile(source)
//    }

//    override func edit(_ task: Task, _ status: Bool) {
//        super.edit(task, status)
//        storage.saveJsonToFile(source)
//    }
}
