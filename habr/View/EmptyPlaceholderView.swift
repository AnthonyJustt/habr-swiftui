//
//  EmptyView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 03.04.2021.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    var imageName: String
    var rendering: Bool
    var body: some View {
        if rendering {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("EmptyImageColor"))
                .padding()
        } else {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(imageName: "EmptyImage", rendering: true)
    }
}
