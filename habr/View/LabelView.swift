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
            .foregroundColor(Color.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color(red: 255 / 255, green: 227 / 255, blue: 242 / 255))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.pink)
                    )
            )
    }
}

struct labelView_Previews: PreviewProvider {
    static var previews: some View {
        labelView(title: "title_")
    }
}
