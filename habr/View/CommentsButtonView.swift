//
//  CommentsButtonView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 30.03.2021.
//

import SwiftUI

struct CommentsButtonView: View {
    var comments: String
    var body: some View {
        GroupBox{
            HStack {
                Image(systemName: "bubble.right")
                Text("Комментарии")
                    .foregroundColor(Color("FeedListFont"))
                Spacer()
                Text(comments)
            }
        }
    }
}

struct CommentsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsButtonView(comments: "000_")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

