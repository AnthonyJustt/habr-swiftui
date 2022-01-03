//
//  labelView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 25.04.2021.
//

import SwiftUI

struct labelView: View {
    var title: String
    var body: some View {
        Text(title)
            .foregroundColor(Color("FeedListFont"))
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color("AccentColor"))
                    .opacity(0.2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color("AccentColor"))
                    )
            )
            .padding(.vertical)
    }
}

struct labelView_Previews: PreviewProvider {
    static var previews: some View {
        labelView(title: "title_")
            .previewLayout(.sizeThatFits)
            .padding()
           // .preferredColorScheme(.dark)
    }
}
