//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Emmanuel Chucks on 08/12/2021.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var model: Model
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                .accessibilityElement()
                
                Text("Your total is \(model.order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order") {
                    Task {
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(model.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Model.Order.self, from: data)
            
            alertTitle = "Thank you!"
            alertMessage = "Your order of \(decodedOrder.quantity)x \(Model.Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
        } catch {
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            print("Failed to check out")
        }
        
        showingAlert = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(model: Model())
    }
}
