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
    }
    
    override func fetch(_ callback: @escaping (Error?) -> Void) {

        super.fetch() {
            guard let group : [Group] = self.storage.getData() else {
                print("Group empty")
                self.saveDefaultData()
                print("Save default data")
                return
            }

            self.source = group

            callback($0)
        }
    }

    private func saveDefaultData() {
        super.defaultGroup()
        
        storage.saveJsonToFile(source) { _ in }
    }
    
    override func add(_ task: Task, _ callback: @escaping (Error?) -> Void) {
        
        // add task in cash
        super.add(task) {
            self.save() {
                callback($0) }
            callback($0)
        }
    }
    
    override func edit(_ task: Task, _ callback: @escaping (Error?) -> Void) {
        
        // edit task in cash
        super.edit(task) {
            self.save() {
                callback($0) }
            callback($0)
        }
    }
    
    override func delete(_ task: Task, _ callback: @escaping (Error?) -> Void) {
        
        // edit task in cash
        super.delete(task) {
            self.save() {
                callback($0) }
            callback($0)
        }
    }
    
    private func save(_ callback: @escaping (Error?) -> Void) {

        // save all tasks from cash in local file
        self.storage.saveJsonToFile(self.source) { result in
            guard result == nil else {
                callback(result)
                return
            }
            
            callback(nil)
        }
    }
}
