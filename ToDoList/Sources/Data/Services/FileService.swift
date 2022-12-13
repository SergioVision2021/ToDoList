//swiftlint:disable all
//  MemoryService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

class FileService: LocalStorage {
    
    var storage: StorageHelper

    init() {
        self.storage = StorageHelper(folderName: "ToDoList", fileName: "Data")
    }
    
    func fetch(_ completionHandler: @escaping (Result<Data, Error>) -> ()) {

        guard let model: Task = storage.getData() else {
            print("Tasks empty")
            completionHandler(Result.failure(LocalStorageError.emptyData))
            return
        }
        
        guard let data = CoderJSON().encoderJSON(model) else { return }
        
        completionHandler(Result.success(data))
    }
    
    func saveAll(_ data: Data, completionHandler: @escaping (Error?) -> ()) {
        
        // save all tasks from cash in local file
        guard let data: [Task] = CoderJSON().decoderJSON(data) else { return}

        storage.saveJsonToFile(data) {
            completionHandler($0)
        }
    }
    
    func removeAll(_ data: Data, completionHandler: @escaping (Result<Void, Error>) -> ()) {
        //
    }
}
