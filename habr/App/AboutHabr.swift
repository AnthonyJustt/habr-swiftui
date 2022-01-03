//
//  AboutHabr.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 28.04.2021.
//

import SwiftUI

struct AboutHabr: View {
    @State private var s: String = ""
    var body: some View {
        ScrollView {
            VStack {
                Text(LocalizedStringKey("AboutHabr"))
                    .padding()
                    .lineLimit(nil)
                    .onAppear(
                        perform: {
                            
                            //   s =  fparseAbout(fhtml: fname(furl: "https://habr.com/ru/about/")).1
                        }
                    )
            }
            .navigationTitle(LocalizedStringKey("More.AboutHabr"))
        }
        
    }
}

struct AboutHabr_Previews: PreviewProvider {
    static var previews: some View {
        AboutHabr()
    }
}
