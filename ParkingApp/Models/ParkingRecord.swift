//
//  ParkingRecord.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import Foundation
import FirebaseFirestoreSwift


struct ParkingRecord : Codable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var buildingCode : String
    var hours: Int
    var plate: String
    var suit: String
    var address: String
    var datetime: Date = Date()
    
}


extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
