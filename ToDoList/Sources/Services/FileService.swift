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

        guard let data = storage.getData() else { return }
        guard !data.isEmpty else {
            print("Data empty")
            saveDefaultData()
            print("Save default data")
            return
        }

        guard let group: [Group] = storage.decoderJSON(data) else { return }
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
