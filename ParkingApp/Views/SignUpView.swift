//
//  SignUpView.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var confirmPassword : String = ""
    @State private var contactNum : String = ""
    @State private var plate : String = ""
    
    var body: some View {
        
        VStack{
            Form{
//                Text("Enter Signup details:")
//                    .padding(.vertical)
//                    .font(.headline)
                TextField("Name", text: self.$name)
                    .textInputAutocapitalization(.never)
                    .padding(.vertical, 10)
                
                TextField("Email", text: self.$email)
                    .textInputAutocapitalization(.never)
                    .padding(.vertical, 10)
                
                SecureField("Password", text: self.$password)
                    .textInputAutocapitalization(.never)
                    .padding(.vertical, 10)
                
                SecureField("Confirm Password", text: self.$confirmPassword)
                    .textInputAutocapitalization(.never)
                    .padding(.vertical, 10)
                
                TextField("Contact Number", text: self.$contactNum)
                    .padding(.vertical, 10)
                
                TextField("Car License Plate", text: self.$plate)
                    .textCase(.uppercase)
                    .padding(.vertical, 10)
                
            }
            .autocorrectionDisabled(true)
            
            Button(action: {
                //validate the data such as no mandatory inputs, password rules, etc.
                
                //create user account on FirebaseAuth
                self.authHelper.signUp(name: self.name, email: self.email, password: self.password, contactNum: self.contactNum, plate: self.plate)
                
                let newUser:UserProfile = UserProfile(name: self.name, email: self.email, contactNum: self.contactNum, plate: self.plate)
                
                self.dbHelper.insertUser(newUser: newUser)
                
                self.dismiss()
            }){
                Text("Create Account")
                    .padding()
            }.buttonStyle(.borderedProminent)
                .disabled(self.password != self.confirmPassword || self.email.isEmpty || self.password.isEmpty || self.confirmPassword.isEmpty)
        }
        .navigationTitle("SignUp Form")
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
