//
//  DetailsView.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import SwiftUI

struct DetailsView: View {
    
    let selectedParkIndex : Int
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dbHelper : FirestoreController
    
    @State private var buildingCode : String = ""
    @State private var hours : Int = 1
    @State private var plate : String = ""
    @State private var suit : String = ""
    @State private var address : String = ""
    @State private var dateTime = Date()
    
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack{
            
            List{
                HStack{
                    Text("Building Code: ").foregroundColor(.gray)
                    Spacer()
                    TextField("Building Code", text: $buildingCode)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.vertical, 10)
                
                Picker("Hours to Park", selection: $hours) {
                    Text("1 hour or less").tag(1)
                    Text("4 hours").tag(4)
                    Text("12 hours").tag(12)
                    Text("24 hours").tag(24)
                }.foregroundColor(.gray)
                .padding(.vertical, 5)
                
                HStack{
                    Text("License Plate: ").foregroundColor(.gray)
                    Spacer()
                    TextField("License Plate Number", text: $plate)
                }
                .padding(.vertical, 10)
                HStack{
                    Text("Host Suite Number: ").foregroundColor(.gray)
                    Spacer()
                    TextField("Host Suite Number", text: $suit)
                }
                .padding(.vertical, 10)
                HStack{
                    Text("Parking Location: ").foregroundColor(.gray)
                    Spacer()
                    TextField("Parking Location", text: $address)
                }
                .padding(.vertical, 10)
                DatePicker("Time", selection: $dateTime, displayedComponents: [.date, .hourAndMinute])
                    .foregroundColor(.gray)
                    .disabled(true)

            }
            
            Button{
                
                if validateInputs() {
                    
                    var updatedPark: ParkingRecord = ParkingRecord(buildingCode: self.buildingCode, hours: self.hours, plate: self.plate, suit: self.suit, address: self.address)
                    
                    updatedPark.id = self.dbHelper.parkList[selectedParkIndex].id
                    updatedPark.datetime = self.dateTime
                    
                    self.dbHelper.updatePark(parkToUpdate: updatedPark)
                    
                    self.dbHelper.parkList[selectedParkIndex] = updatedPark
                    
                    dismiss()
                    
                }
                else{
                    showErrorAlert = true
                }
            }label: {
                Text("Save")
                    .bold()
                    .padding(.horizontal, 50)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.borderedProminent)
            .navigationTitle("Parking Details")
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear(){
            let selectedPark : ParkingRecord = self.dbHelper.parkList[selectedParkIndex]
            self.buildingCode = selectedPark.buildingCode
            self.hours = selectedPark.hours
            self.plate = selectedPark.plate
            self.suit = selectedPark.suit
            self.address = selectedPark.address
            self.dateTime = selectedPark.datetime
        }
    }//body
    
    func validateInputs() -> Bool {
        if (self.buildingCode.count != 5 || !self.buildingCode.isAlphanumeric) {
            self.errorMessage = "Building Code must be exactly 5 alphanumeric characters."
                return false
            }

        if self.plate.count < 2 || self.plate.count > 8 || !self.plate.isAlphanumeric {
            self.errorMessage = "License Plate number must be between 2 and 8 alphanumeric characters."
                return false
            }

        if self.suit.count < 2 || self.suit.count > 5 || !self.suit.isAlphanumeric {
            self.errorMessage = "Host Suite Number must be between 2 and 5 alphanumeric characters."
                return false
            }

            return true
    }
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}
