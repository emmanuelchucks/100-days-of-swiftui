//
//  ContentView.swift
//  BetterRest
//
//  Created by Emmanuel Chucks on 27/11/2021.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUpTime =  defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    var correctedCoffeeAmount: Int {
        coffeeAmount + 1
    }
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    Section("When do you want to wake up?") {
                        DatePicker("Please select a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    Section("Desired amount of sleep") {
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    
                    Section("Daily coffee intake") {
                        Picker(correctedCoffeeAmount == 1 ? "1 cup" : "\(correctedCoffeeAmount) cups", selection: $coffeeAmount) {
                            ForEach(1..<21) {
                                Text("\($0)")
                            }
                        }
                    }
                }
                
                VStack {
                    Text("Your ideal bedtime is...")
                        .font(.subheadline)
                    Text(bedTime.formatted(date: .omitted, time: .shortened))
                        .font(.largeTitle)
                        .bold()
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    var bedTime: Date {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            return wakeUpTime - prediction.actualSleep
        } catch {
            return Date.now
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
