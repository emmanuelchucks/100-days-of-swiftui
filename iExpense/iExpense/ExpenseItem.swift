//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Emmanuel Chucks on 04/12/2021.
//

import Foundation

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    
    let name: String
    let type: String
    let amount: Double
}
