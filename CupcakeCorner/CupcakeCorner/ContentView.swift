//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Emmanuel Chucks on 07/12/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = Model()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $model.order.type) {
                        ForEach(Model.Order.types.indices) {
                            Text(Model.Order.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(model.order.quantity)", value: $model.order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $model.order.specialRequestEnabled.animation())
                    
                    if model.order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $model.order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $model.order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(model: model)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
