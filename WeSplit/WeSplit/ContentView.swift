//
//  ContentView.swift
//  WeSplit
//
//  Created by Emmanuel Chucks on 22/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    
    @FocusState private var amountIsFocused: Bool
    
    var totalCheckAmount: Double {
        let valueOfTip = Double(tipPercentage) / 100 * checkAmount
        return checkAmount + valueOfTip
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        return totalCheckAmount / peopleCount
    }
    
    let tipPercentages = [0, 10, 15, 20, 25]
    let localCurrency: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "USD")
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Amount", value: $checkAmount, format: localCurrency
                        )
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                        
                        Picker("Number of people", selection: $numberOfPeople) {
                            ForEach(2..<100) {
                                Text("\($0) people")
                            }
                        }
                        
                    }
                    
                    Section {
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(0..<101) {
                                Text("\($0)%")
                            }
                        }
                    } header: {
                        Text("How much tip?")
                    }
                    
                    Section {
                        Text(totalCheckAmount, format: localCurrency)
                            .foregroundColor(tipPercentage == 0 ? .red : .primary)
                    } header: {
                        Text("Total check amount")
                    }
                }
                
                Text("Amount per person")
                    .font(.subheadline)
                Text(totalPerPerson, format: localCurrency)
                    .font(.largeTitle)
                    .bold()
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
