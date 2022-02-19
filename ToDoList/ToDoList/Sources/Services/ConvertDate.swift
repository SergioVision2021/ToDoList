//
//  ConvertDate.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

class ConvertDate{

    func convert(from text: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: text)
    }

    func convert(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    func intervaleString(end date: Date?) -> String {
        var status = String()
        
        if let endDate = date{
            let number = intervaleDate(to: endDate)
            
            switch number{
                case ..<0: status = "Late"
                case 0: status = "ToDay"
                case 1: status = "Tomorrow"
                case 2...: status = "Through \(number) day(s)"
                default: break
            }
        }
        return status
    }

    func intervaleDate(to endDate: Date, startDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let numberOfDays = components.day ?? 0
        
        print(numberOfDays)
        
        return numberOfDays
    }
}
