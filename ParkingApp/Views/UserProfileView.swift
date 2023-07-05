//
//  UserProfileView.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @Binding var rootScreen : RootView
    
    @State private var name : String = ""
    @State private var email : String = ""
    @State private var contactNum : String = ""
    @State private var plate : String = ""
    
    var loggedInUserEmail : String = ""
    
    @State private var showErrorAlert = false
    
    var body: some View {
        
        VStack{
            List{
                Text("User details:").font(.headline)
                    .padding()
                TextField("Name", text: self.$name)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Email", text: self.$email)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
                
                TextField("Contact Number", text: self.$contactNum)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Car Plate", text: self.$plate)
                    .textCase(.uppercase)
                    .textFieldStyle(.roundedBorder)
                
            }
            .autocorrectionDisabled(true)
            
            Button(action: {
                var updatedUser: UserProfile = UserProfile(name: self.name, email: self.email, contactNum: self.contactNum, plate: self.plate)
                
                updatedUser.id = self.dbHelper.userDetailsArray.first(where: ({$0.email == self.email}))?.id
                
                self.dbHelper.updateUserDetails(userToUpdate: updatedUser)
                
                self.showErrorAlert = true
            }){
                Text("Update Account")
                    .padding()
            }.buttonStyle(.borderedProminent)
                .disabled( self.email.isEmpty || self.name.isEmpty)
                .padding(.vertical,30)
            
            Button{
                self.dbHelper.deleteUserData()
                
                //sign out using Auth
                self.authHelper.signOut()
                
                //dismiss current screen and show login screen
                self.rootScreen = .Login
                
            }label:{
                Text("Delete Account Data")
                    .bold()
                    .padding()
            }.buttonStyle(.bordered)
                .background(.red)
                .foregroundColor(.white)
                .disabled( self.email.isEmpty || self.name.isEmpty)
                .padding(.vertical,30)
                .cornerRadius(10)
        }//vstack
        .onAppear(){
            self.dbHelper.getUserDetails()
            dbHelper.userDetailsArray.forEach{ usr in
                self.name = usr.name
//                print(usr.name)
                self.email = usr.email
//                print(usr.email)
                self.contactNum = usr.contactNum
                self.plate = usr.plate
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Success!"), message: Text("Details Updated"), dismissButton: .default(Text("OK")))
        }
    }//body
}

//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileView()
//    }
//}
