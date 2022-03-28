//  MemoryService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

// JSON

class FileService: TaskService {

    //var storage = StorageHelper<Group>(folderName: "TodoList")

    var storage = StorageHelper(folderName: "ToDoList", fileName: "Data")

    override init() {
        super.init()

        guard let data = storage.getData() else { return }

        // Нет данных
        guard !data.isEmpty else {
            empty = true
            print("Data empty")
            saveDefaultData()
            return
        }

        // Преобразовать данные в JSON
        guard let group = storage.decoderJSON(data) else {
            print("json decoder error")
            return
        }

        source = group
    }

    func saveDefaultData() {
        super.defaultGroup()
        storage.saveJsonToFile(source)
    }

    override func add(_ group: [Group]) {
        super.add(group)
        storage.saveJsonToFile(source)
    }

    override func edit(_ task: Task, _ status: Bool) {
        super.edit(task, status)
        storage.saveJsonToFile(source)
    }
}
