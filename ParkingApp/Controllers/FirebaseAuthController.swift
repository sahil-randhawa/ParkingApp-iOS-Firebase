//
//  FirebaseAuthController.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import Foundation
import FirebaseAuth


class FireAuthController : ObservableObject{
    
    //using inbuilt User object provided by FirebaseAuth
    @Published var user : User?{
        didSet{
            objectWillChange.send()
        }
    }
    
    @Published var isLoginSuccessful = false
    
    func listenToAuthState(){
        Auth.auth().addStateDidChangeListener{ [weak self] _, user in
            guard let self = self else{
                //no change in user's auth state
                return
            }
            
            //user's auth state has changed ; update the user object
            self.user = user
        }
    }

    
    func signUp(name: String, email: String, password : String, contactNum: String, plate: String){
        
        Auth.auth().createUser(withEmail : email, password: password){ authResult, error in
            
            guard let result = authResult else{
                print(#function, "Error while signing up user : \(error)")
                return
            }
            
            print(#function, "AuthResult : \(result)")
            
            switch(authResult){
            case .none:
                print(#function, "Unable to create account")
            case .some(_):
                print(#function, "Successfully created user account")
                
                self.user = authResult?.user
                //save the email in the UserDefaults
                UserDefaults.standard.set(self.user?.email, forKey: "KEY_EMAIL")
            }
            
        }
        
    }
    
    func signIn(email: String, password : String, withCompletion completion: @escaping (Bool) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password){authResult, error in
            guard let result = authResult else{
                print(#function, "Error while signing in user : \(error)")
                return
            }
            
            print(#function, "AuthResult : \(result)")
            
            switch(authResult){
            case .none:
                print(#function, "Unable to find user account")
                
                DispatchQueue.main.async {
                    self.isLoginSuccessful = false
                    completion(self.isLoginSuccessful)
                }
                
            case .some(_):
                print(#function, "Login Successful")
                
                self.user = authResult?.user
                //save the email in the UserDefaults
                UserDefaults.standard.set(self.user?.email, forKey: "KEY_EMAIL")
                
                print(#function, "user email : \(self.user?.email)")
                print(#function, "user displayName : \(self.user?.displayName)")
                print(#function, "user isEmailVerified : \(self.user?.isEmailVerified)")
                print(#function, "user phoneNumber : \(self.user?.phoneNumber)")
                
                DispatchQueue.main.async {
                    self.isLoginSuccessful = true
                    completion(self.isLoginSuccessful)
                }
            }
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch let err as NSError{
            print(#function, "Unable to sign out : \(err)")
        }
    }
}
