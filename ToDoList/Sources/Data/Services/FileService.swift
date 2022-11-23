//swiftlint:disable all
//  MemoryService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

class FileService: LocalStorage {
    
    var storage: StorageHelper<Group>

    init() {
        self.storage = StorageHelper(folderName: "ToDoList", fileName: "Data")
    }
    
    func fetch(_ completionHandler: @escaping (Result<[Group], Error>) -> ()) {

        guard let model: [Group] = storage.getData() else {
            print("Group empty")
            completionHandler(Result.failure(LocalStorageError.emptyData))
            return
        }
        
        completionHandler(Result.success(model))
    }
    
    func saveAll(_ task: [Group], completionHandler: @escaping (Error?) -> ()) {
        
        // save all tasks from cash in local file
        storage.saveJsonToFile(task) {
            completionHandler($0)
        }
    }
    
    func removeAll(_ task: [Group], completionHandler: @escaping (Result<Void, Error>) -> ()) {
        //
    }
}
