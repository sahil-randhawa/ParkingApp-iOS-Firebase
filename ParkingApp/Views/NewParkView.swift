//
//  NewParkView.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import SwiftUI

struct NewParkView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dbHelper : FirestoreController
    
    @State private var buildingCode : String = ""
    @State private var hours : Int = 1
    @State private var plate : String = ""
    @State private var suit : String = ""
    @State private var address : String = ""
    
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
//    private var contribution : Int {
//        return Int(strContribution) ?? 0
//    }
    
    var body: some View {
        VStack{
            
            List{
                TextField("Building Code", text: $buildingCode)
                    .padding(.vertical, 10)
                
                Picker("Hours to Park", selection: $hours) {
                    Text("1 hour or less").tag(1)
                    Text("4 hours").tag(4)
                    Text("12 hours").tag(12)
                    Text("24 hours").tag(24)
                }
                .padding(.vertical, 5)
                
                TextField("License Plate Number", text: $plate)
                    .padding(.vertical, 10)
                TextField("Host Suite Number", text: $suit)
                    .padding(.vertical, 10)
                TextField("Parking Location", text: $address)
                    .padding(.vertical, 10)
            }
            
            Button{
                
                //validate the data for any missing fields or required format
                
                if validateInputs() {
                    
                    //create an instance of model class hat conforms to Codable
                    let newPark = ParkingRecord(buildingCode: self.buildingCode, hours: self.hours, plate: self.plate, suit: self.suit, address: self.address)
    
                    //save new employee to database
                    self.dbHelper.insertParking(newPark: newPark)
                    
                    dismiss()
                    
                    
                    // Clear the input fields
                    buildingCode = ""
                    hours = 1
                    plate = ""
                    suit = ""
                    address = ""
                } else {
                    showErrorAlert = true
                }
            }label: {
                Text("Save")
                    .bold()
                    .padding(.horizontal, 50)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.borderedProminent)
            .navigationTitle("Add Parking Record")
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        
    }
    func validateInputs() -> Bool {
        if (self.buildingCode.count != 5 || !self.buildingCode.isAlphanumeric) {
            self.errorMessage = "Building code must be exactly 5 alphanumeric characters."
                return false
            }

        if self.plate.count < 2 || self.plate.count > 8 || !self.plate.isAlphanumeric {
            self.errorMessage = "License plate number must be between 2 and 8 alphanumeric characters."
                return false
            }

        if self.suit.count < 2 || self.suit.count > 5 || !self.suit.isAlphanumeric {
            self.errorMessage = "Host suite number must be between 2 and 5 alphanumeric characters."
                return false
            }

            return true
    }
}

struct NewParkView_Previews: PreviewProvider {
    static var previews: some View {
        NewParkView()
    }
}
