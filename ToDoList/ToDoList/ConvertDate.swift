//
//  ConvertDate.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import Foundation

class ConvertDate{
    func convert(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YY/MM/dd"
        let strDate = formatter.string(from: date)
        return strDate
    }
}
