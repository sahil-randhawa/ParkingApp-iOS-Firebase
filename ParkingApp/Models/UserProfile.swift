//
//  UserProfile.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import Foundation
import FirebaseFirestoreSwift

struct UserProfile : Codable, Hashable{
    
    @DocumentID var id: String? = UUID().uuidString
    var name : String = ""
    var email : String = ""
    var contactNum : String = ""
    var plate : String = ""
}
