//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Emmanuel Chucks on 07/12/2021.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var model: Model
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $model.order.name)
                TextField("Street address", text: $model.order.streetAddress)
                TextField("City", text: $model.order.city)
                TextField("Zip", text: $model.order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(model: model)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(model.order.hasInvalidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(model: Model())
    }
}
