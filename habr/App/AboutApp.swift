//
//  AboutApp.swift
//  AboutApp
//
//  Created by Anton Krivonozhenkov on 08.08.2021.
//

import SwiftUI

struct AboutApp: View {
    @State private var isAnimatingImage: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing:0) {
            Image("aboutApp")
                .resizable()
                .scaledToFit()
        Spacer()
        VStack {
            GroupBox (
            label:
                HStack {
                    Text("Application".uppercased()).fontWeight(.bold)
                    Spacer()
                    Image(systemName: "apps.iphone")
                }
            ) {
                SettingsRowView(name: "Developer", content: "Anthony K.")
                SettingsRowView(name: "Website", linkLabel: "site", linkDestination: "apple.com")
                SettingsRowView(name: "SwiftUI", content: "2.0")
                SettingsRowView(name: "Version", content: "0.9")
            }
        }
        .padding()
            
            Spacer()
            
        }
        .edgesIgnoringSafeArea(.top)
        
        
    }
}

struct SettingsRowView: View {
    
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    var body: some View {
        VStack {
            Divider().padding(.vertical, 4)
            HStack{
                Text(name).foregroundColor(.gray)
                Spacer()
                if (content != nil) {
                    Text(content!)
                }
                else if (linkLabel != nil && linkDestination != nil) {
                    Link(linkLabel!, destination: URL(string: "https://\(linkDestination!)")!)
                    Image(systemName: "arrow.up.right.square").foregroundColor(.pink)
                }
                else {
                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                }
            }
        }
    }
}

struct AboutApp_Previews: PreviewProvider {
    static var previews: some View {
        AboutApp()
    }
}
