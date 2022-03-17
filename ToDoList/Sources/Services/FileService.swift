//
//  MemoryService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

// JSON

class FileService: TaskService {

    var taskService = TaskService()

    var file = File()

    // Загрузить из файлв JSON
    func load() {
        // Получить путь файла
        guard let fileURL = file.existFolderFile(flag: "set") else {
            return print("Could not get file URL")
        }

        // Получить данные из файла
        guard let data = try? Data(contentsOf: fileURL) else {
            return print("Could not convert to data")
        }

        // Нет данных
        guard !data.isEmpty else {
            taskService.empty = true
            return print("Data empty")
        }

        // Преобразовать данные в JSON
        guard let data = decoderJSON(data) else {
            return print("json decoder error")
        }

        taskService.source = data
    }

    override func add(_ group: [Group]) {
        taskService.add(group)

        guard let data = encoderJSON(taskService.source) else {
            return print("json encoder error")
        }

        file.saveJsonToFile(data)
    }

    override func edit(_ task: Task, _ status: Bool) {
        taskService.edit(task, status)

        // Преобразовать в JSON и сохранить в файл
        guard let data = encoderJSON(taskService.source) else {
            return print("json encoder error")
        }

        file.saveJsonToFile(data)
    }
    
    

    override func filterPeriod() -> [Group]? {
        return taskService.filterPeriod()
    }

    override func filterToday(_ namePeriod: String) -> [Group]? {
        return taskService.filterToday(namePeriod)
    }

    override func filterAllTasks() -> [String] {
        return taskService.filterAllTasks()
    }

    override func filterGroup() -> [String] {
        return taskService.filterGroup()
    }
}

// MARK: - JSON
extension FileService {
    func decoderJSON(_ json: Data) -> [Group]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let group = try? decoder.decode([Group].self, from: json) else {
            print("Decoder error")
            return nil
        }

        return group
    }

    func encoderJSON(_ task: [Group]) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(task) else {
            print("Encoder error")
            return nil
        }

        print(String(data: encodedData, encoding: .utf8))

        return encodedData
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
