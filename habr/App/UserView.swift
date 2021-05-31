//
//  UserView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import SwiftUI

struct UserView: View {
    
    @State private var isShowingSettings: Bool = false
    
    @State var counter: String = ""
    
    var body: some View {
     //   NavigationView{
            //  Text("user")
            
            VStack {
                VStack {
                    Image("onBoardingImage")
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: 74.0, height: 74.0)
                        .padding(Edge.Set.bottom, 20)
                    
                    Text("Вход").bold().font(.title)
                    
                    Text("Войти с помощью Хабр Аккаунта")
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 70, trailing: 0))
                    
                    TextField("email", text: $counter)
                        .padding()
                        .cornerRadius(8.0)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("AccentColor"), lineWidth: 1))
                      //  .padding()
                    
                    TextField("password", text: $counter)
                        .padding()
                        .cornerRadius(8.0)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("AccentColor"), lineWidth: 1))
                      //  .padding()
                    
                    Button(action: {}) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Войти")
                                .foregroundColor(.white)
                                .bold()
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color("AccentColor"))
                    .cornerRadius(8.0)
                    
                }
                .padding()
                
                .navigationTitle("Профиль")
                .navigationBarItems(trailing:
                                        Button (action:{
                                            isShowingSettings = true
                                        }){
                                            Image(systemName: "slider.horizontal.3")
                                        }
                    .sheet(isPresented: $isShowingSettings){
                        SettingsView()
                    }
                )
            }
      //  }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
