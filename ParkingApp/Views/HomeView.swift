//
//  HomeView.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @Binding var rootScreen : RootView
    
    var body: some View {
        
            ZStack(alignment: .bottom){
                if (self.dbHelper.parkList.isEmpty){
                    Text("There are no parking records in the database yet")
                        .padding(.vertical,50)
                }else{
                    List{
                        ForEach(self.dbHelper.parkList.enumerated().map({$0}), id: \.element.self){index, park in
                            
                            NavigationLink{
                                DetailsView(selectedParkIndex: index).environmentObject(self.dbHelper)
                            }label:{
                                HStack{
                                    Text("\(park.plate)")
                                        .bold()
                                    Spacer()
                                    Text("\(park.hours) hours")
                                }//HStack
                            }//Navigation Link
                            
                        }//ForEach
                        .onDelete(perform: { indexSet in

                            for index in indexSet{

                                //get the employee object to delete
                                let park = self.dbHelper.parkList[index]

                                //delete the document from database
                                self.dbHelper.deleteParking(parkToDel: park)
                            }
                        })//onDelete
                    }//List
                }//else
                
                NavigationLink{
                   NewParkView().environmentObject(self.dbHelper)
                }label:{
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height:60, alignment: .bottom)
                        .foregroundColor(Color.blue)
                        .padding()
                }
                
            }//ZStack
            .onAppear(){
                //remove old data from list
                self.dbHelper.parkList.removeAll()
                
                //fetch all documents from database
                self.dbHelper.getAllParking()
                
                self.dbHelper.getUserDetails()
            }
            
            .navigationTitle("Parking Records")
        
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action: {
                        //sign out using Auth
                        self.authHelper.signOut()
                        
                        //dismiss current screen and show login screen
                        self.rootScreen = .Login
                        
                    }, label: {
                        Text("Sign out")
                    })
                }
            }//toolbar
        
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
