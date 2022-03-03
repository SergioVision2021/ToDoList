// swiftlint:disable all
//  TaskService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

class TaskService {
    
    enum TypeData {
        case swift, json
    }
    
    var source = [Group]()
    var filtredData = [Group]()
    var empty = false
    
    init(typeData: TypeData) {
        switch typeData {
        case .swift:
            loadDataSwift()
        case .json:
            loadDataJSON()
        }
    }
    
    // Загрузить готовый объект
    func loadDataSwift() {
        source = DataSwift().source
    }
    
    // Загрузить из файлв JSON
    func loadDataJSON() {
        // Получить путь файла
        guard let fileURL = existFolderFile(flag: "set") else {
            return print("Could not get file URL")
        }
        
        // Получить данные из файла
        guard let data = try? Data(contentsOf: fileURL) else {
            return print("Could not convert to data")
        }
        
        // Нет данных
        guard !data.isEmpty else {
            empty = true
            return print("Data empty")
        }

        // Преобразовать данные в JSON
        decoderJSON(data)
    }

    // Для InBoxViewController
    func filterPeriod() -> [Group]? {

        filtredData.removeAll()

        var sections = [String]()
        var tasks = [(Int, Task)]()

        for sourceIndex in 0..<source.count {
            if let countL = source[sourceIndex].list?.count {
                for listIndex in 0..<countL {
                    // Получить период до планируемой даты
                    let intervale = ConvertDate().intervaleString(end: source[sourceIndex].list?[listIndex].taskScheduledDate)
                    if !sections.contains(intervale) {
                        // Массив всех периодов
                        sections.append(intervale)
                    }
                    // Массив всех задач Id = section, Task = value
                    if  let task = source[sourceIndex].list?[listIndex],
                        let id = sections.index{ $0 == intervale } {
                            tasks.append((id, task))
                    }
                }
            }
        }

        for secIdx in 0..<sections.count {                 // Section
            var sectionTasks = [Task]()
            for taskIdx in 0..<tasks.count where secIdx == tasks[taskIdx].0 {                // Task
                sectionTasks.append(tasks[taskIdx].1)
            }
            filtredData.append(Group.init(id: secIdx, name: sections[secIdx], list: sectionTasks))
        }
        return filtredData
    }

    // Для TodayViewController
    func filterToday(namePeriod: String) -> [Group]? {
        filterPeriod()

        guard filtredData.count != 0 else {
            return nil
        }

        // Из всех секций (периодов) = получить секцию ToDay
        var sectionToDay = [Group]()

        for currentIdx in 0..<filtredData.count where filtredData[currentIdx].name == namePeriod {
            sectionToDay = [filtredData[currentIdx]]
            break
        }

        guard sectionToDay.count != 0 else {
            return nil
        }

        // Создать 2е секции по статусу тасков из секции ToDay
        var statusToDay = [Group]()
        
        if let taskCount = sectionToDay[0].list?.count {
            var taskCompleted = [Task]()
            var taskIncomplete = [Task]()
            for taskIdx in 0..<taskCount {
                if let task = sectionToDay[0].list?[taskIdx] {
                    switch task.status {
                    case true: taskCompleted.append(task)
                    case false: taskIncomplete.append(task)
                    default: break
                    }
                }
            }
            statusToDay.append(Group.init(id: 0, name: "Completed", list: taskCompleted))
            statusToDay.append(Group.init(id: 1, name: "Incomplete", list: taskIncomplete))
        }
        return statusToDay
    }

    func filterAllTasks() -> [String] {
        var allNames = [String]()

        source.map { $0.list.map { $0.map { allNames.append($0.name!) } } }
        
        //        for sourceIdx in 0..<source.count {
        //            if let countL = source[sourceIdx].list?.count {
        //                for listIdx in 0..<countL {
        //                    allNames.append(source[sourceIdx].list?[listIdx].name ?? "")
        //                }
        //            }
        //        }
        return allNames
    }

    func filterGroup() -> [String] {
        return source.map {str in str.name ?? ""}
    }

    // AddTask - добавить новую задачу
    func appendTask(_ newTask: [Group]) {
        guard let task = newTask[0].list else {
            return print("Task data not")
        }
        
        if empty {
            source = newTask
            empty = false
        } else {
            source[0].list?.append(contentsOf: task)
        }
        
        encoderJSON(source)
    }
    
    func defaultGroup() {
        source.insert(Group(id: 0,
                            name: "InBox",
                            dateCreated: Date(),
                            list: nil),
                      at: 0)
    }

    // DetailTask - завершить задачу
    func editTask(_ editTask: Task) {
        let idGroup = editTask.id ?? 0
        let count = source[idGroup].list?.count ?? 0

        for idx in 0..<count where source[idGroup].list?[idx].name == editTask.name {
            source[idGroup].list?[idx].taskDeadline = Date()
            source[idGroup].list?[idx].status = true
            break
        }
        
        // Преобразовать в JSON и сохранить в файл
        encoderJSON(source)
    }
}

// MARK: - Loader contents
extension TaskService {
    
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

// MARK: - JSON
extension TaskService {

    func decoderJSON(_ json: Data) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let group = try? decoder.decode([Group].self, from: json) else {
            return print("Decoder error")
        }

        source = group
    }
    
    func encoderJSON(_ task: [Group]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let encodedData = try? encoder.encode(task) else {
            return print("Encoder error")
        }
        
        print(String(data: encodedData, encoding: .utf8))
        
        saveJsonToFile(encodedData)
    }

    //        guard let file = Bundle.main.url(forResource: "Data", withExtension: "json")          else {
    //            fatalError("Could not find Data.json")
    //        }

    // func dataJSON() {
        //
        //Example1
        //        do {
        //            let data = try Data(contentsOf: file)
        //
        //            // Декодирование из объекта JSON
        //            let decoder = JSONDecoder()
        //
        //                // decoder.dateDecodingStrategy = .formatted(formate)
        //                decoder.dateDecodingStrategy = .iso8601
        //                let dataFromJson = try decoder.decode([GroupJSON].self, from: data)
        //
        //            // let dataFromJson = try decoder.decode([GroupJSON].self, from: data)
        //
        //            userTasks = dataFromJson
        //        } catch {
        //            print(error)
        //        }
        
        //Example2
        //
        //        let decoder2 = JSONDecoder()
        //        decoder2.dateDecodingStrategy = .iso8601
        //        guard let userTasks = try? decoder2.decode([Group].self, from: loadFile()) else {
        //            fatalError("There must be a problem decoding the data.....")
        //        }
        //
        //        for task in userTasks {
        //            print(task.id)
        //            print(task.name)
        //            print(task.dateCreated)
        //            print(task.list)
        //        }
        // var sort = group.sorted(by: { $0.id! < $1.id! })
    // }
    
    //        let json = """
    //            [
    //                {
    //                    "id": 0,
    //                    "name": "Inbox",
    //                    "list": [
    //                                {
    //                                    "id": 0,
    //                                    "name": "task 0",
    //                                    "taskScheduledDate": "2022-02-25T12:45:00Z",
    //                                    "notes": "text",
    //                                    "status": false
    //                                }
    //                            ]
    //                }
    //            ]
    //        """

    //        guard let jsonData = json.data(using: .utf8) else {
    //            fatalError("Could not convert to data")
    //        }
            
    //        let formate = DateFormatter()
    //        formate.dateFormat = "yyyy-MM-dd"
}
