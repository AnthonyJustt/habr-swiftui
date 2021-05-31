//
//  buttonOriginalView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 25.04.2021.
//

import SwiftUI

struct buttonOriginalView: View {
    var author: String
    
    func str(s: String) -> String {
        var ss: String = ""
        if let range = s.range(of: ": ") {
            ss = String(s[range.lowerBound...])
            ss.removeFirst()
            ss.removeFirst()
        }
        return ss
    }
    
    var body: some View {
        GroupBox {
            HStack {
                Image(systemName: "globe")
                Text("Автор")
                Spacer()
                Link(str(s: author), destination: (URL(string: "m.habr.com") ?? URL(string: "https://m.habr.com"))!)
                Group {
                    Image(systemName: "arrow.up.right.square")
                }
                .foregroundColor(.accentColor)
            }
        }
    }
}

struct buttonOriginalView_Previews: PreviewProvider {
    static var previews: some View {
        buttonOriginalView(author: "author_")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
