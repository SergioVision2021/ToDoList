//
//  FileService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

class File {

    func existFolderFile(flag: String) -> URL? {
        let manager = FileManager.default

        guard let documentDirUrl = manager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }
        print(documentDirUrl.path)
        
        let newFolderUrl = documentDirUrl.appendingPathComponent("ToDoList")
        let fileUrl = newFolderUrl.appendingPathComponent("Data.json")

        switch flag {
        case "get":
            return fileUrl
        case "set":
            manager.fileExists(atPath: newFolderUrl.path) ? print("Folder ToDoList found") : createFolder(fm: manager, url: newFolderUrl)
            manager.fileExists(atPath: fileUrl.path) ? print("File Data.json found") : createFile(fm: manager, url: fileUrl)
        default:
            break
        }

        return fileUrl
    }

    func createFolder(fm: FileManager, url: URL) {
        do {
            try fm.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: [:])
            
            print("Created folder ToDoList")
        }catch{
                print(error)
        }
    }

    func createFile(fm: FileManager, url: URL) {
        fm.createFile(
            atPath: url.path,
            contents: nil,
            attributes: [FileAttributeKey.creationDate: Date()])
        
        print("Created file Data.json")
    }
    
    func saveJsonToFile(_ jsonObject: Data) {
        guard let fileUrl = existFolderFile(flag: "get") else { return }
       
        do {
            try jsonObject.write(to: fileUrl)
        } catch {
            print(error)
        }
    }
}
