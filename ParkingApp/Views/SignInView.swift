//
//  SignInView.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var linkSelection : Int? = nil
    
    @Binding var rootScreen : RootView
    
    private let gridItems : [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
            VStack{
                
                Text("Parking App")
                    .font(.title)
                    .padding(.vertical, 30)
                
                NavigationLink(destination: SignUpView().environmentObject(self.authHelper).environmentObject(self.dbHelper), tag : 1, selection: self.$linkSelection){}
                
                Section{
                    TextField("Enter Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
//                        .background(Color.white)
                        .cornerRadius(10)
                        .font(.system(size: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        )
                        .padding(.horizontal)
//                        .padding(.vertical)
                    
                    SecureField("Enter Password", text: self.$password)
                        .autocapitalization(.none)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
//                        .background(Color.white)
                        .cornerRadius(10)
                        .font(.system(size: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        )
                        .padding(.horizontal)
                        .padding(.vertical)
                }
                .autocorrectionDisabled(true)
                
                LazyVGrid(columns: self.gridItems){
                    Button(action: {
                        //validate the data
                        
                        //sign in using Firebase Auth
                        self.authHelper.signIn(email: self.email, password: self.password, withCompletion: { isSuccessful in
                            if (isSuccessful){
                                //show to home screen
                                self.rootScreen = .Home
                            }else{
                                //show the alert with invalid username/password prompt
                                print(#function, "invalid username/password")
                            }
                        })
                        
                    }){
                        Text("Sign In")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        //take user to SignUp screen
                        self.linkSelection = 1
                    }){
                        Text("Sign Up")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }//LazyVGrid
                .padding(.vertical)
            }//VStack
    }//body
}

//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
