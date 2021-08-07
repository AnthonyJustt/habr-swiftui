//
//  formattedCommentView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 04.08.2021.
//

import SwiftUI

struct formattedCommentView_UIKIT: View {
    var string: String
    var body: some View {
        HTMLText(html: string)
            .padding()
    }
}

struct HTMLText: UIViewRepresentable {
    let html: String
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let label = UILabel()
        let htmlTemplate = """
           <!doctype html>
           <html>
             <head>
               <style>
                 body {
                   font-family: -apple-system;
                   font-size: 20px;
                 }
                   blockquote {
                              font-size: 18px;
           background: #D9FFAD;
           }
               </style>
             </head>
             <body>
               \(html)
             </body>
           </html>
           """
        DispatchQueue.main.async {
            //let data = Data(self.html.utf8)
            let data = htmlTemplate.data(using: .utf8)
            if let attributedString = try? NSAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
                label.attributedText = attributedString
                label.lineBreakMode = NSLineBreakMode.byWordWrapping;
                label.translatesAutoresizingMaskIntoConstraints = false
                label.heightAnchor.constraint(equalToConstant: 300).isActive = true
                label.widthAnchor.constraint(equalToConstant: 300).isActive = true
                label.numberOfLines = 0;
            }
        }
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {}
}

struct formattedCommentView_UIKIT_Previews: PreviewProvider {
    static var previews: some View {
        formattedCommentView_UIKIT(string: "<blockquote>hey whats app what are you doing right now beautiful</blockquote> h<br>fff<br>привет как у тебя дела")
    }
}
