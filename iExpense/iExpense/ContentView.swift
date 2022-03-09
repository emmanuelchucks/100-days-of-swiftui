//
//  ContentView.swift
//  iExpense
//
//  Created by Emmanuel Chucks on 01/12/2021.
//

import SwiftUI

struct AmountText: View {
    let amount: Double
    let localCurrency: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "USD")
    
    var body: some View {
        if amount > 100 {
            Text(amount, format: localCurrency)
                .foregroundColor(.red)
        } else if amount > 10 {
            Text(amount, format: localCurrency)
                .foregroundColor(.yellow)
        } else {
            Text(amount, format: localCurrency)
                .foregroundColor(.green)
        }
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(types, id: \.self) { type in
                    Section(type) {
                        ForEach(expenses.items) { item in
                            if type == item.type {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                    }
                                    
                                    Spacer()
                                    
                                    AmountText(amount: item.amount)
                                }
                                .padding(8)
                                .accessibilityElement()
                                .accessibilityLabel("\(item.name) \(item.amount)")
                                .accessibilityHint(item.type)
                                
                            } else {}
                        }
                        .onDelete(perform: removeItems)
                    }
                }
            }
        .navigationTitle("iExpense")
        .toolbar {
            Button {
                showingAddExpense = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(expenses: expenses)
        }
    }
}

func removeItems(at offsets: IndexSet) {
    expenses.items.remove(atOffsets: offsets)
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
