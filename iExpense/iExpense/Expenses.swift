//
//  Expenses.swift
//  iExpense
//
//  Created by Emmanuel Chucks on 04/12/2021.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "ExpenseItems")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "ExpenseItems") {
            if let expenseItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = expenseItems
                return
            }
        }
        
        items = []
    }
}
