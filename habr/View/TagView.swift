//
//  tagView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 24.04.2021.
//

import SwiftUI

struct tagView: View {
    var title: String
    var body: some View {
        Text(title)
            .foregroundColor(Color("FeedListFont"))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                    Capsule()
                    .fill(Color("FeedListItem"))
                    .overlay(
                        Capsule()
                            .stroke(Color("AccentColor"))
                    )
            )
    }
}

struct tagView_Previews: PreviewProvider {
    static var previews: some View {
        tagView(title: "title_")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
