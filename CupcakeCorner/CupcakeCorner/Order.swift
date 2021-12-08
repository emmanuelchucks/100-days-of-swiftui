//
//  Order.swift
//  CupcakeCorner
//
//  Created by Emmanuel Chucks on 07/12/2021.
//

import Foundation
import SwiftUI

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

class Model: ObservableObject {
    @Published var order = Order()
    
    struct Order: Codable {
        static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
        
        var type = 0
        var quantity = 3
        
        var specialRequestEnabled = false {
            didSet {
                if !specialRequestEnabled {
                    extraFrosting = false
                    addSprinkles = false
                }
            }
        }
        
        var extraFrosting = false
        var addSprinkles = false
        
        var name = ""
        var streetAddress = ""
        var city = ""
        var zip = ""
        
        var hasInvalidAddress: Bool {
            name.trimmed().isEmpty || streetAddress.trimmed().isEmpty || city.trimmed().isEmpty || zip.trimmed().isEmpty
        }
        
        var cost: Double {
            var total = Double(quantity) * 2
            total += Double(type) / 2
            
            if extraFrosting {
                total += Double(quantity)
            }
            
            if addSprinkles {
                total += Double(quantity) / 2
            }
            
            return total
        }
    }
}
