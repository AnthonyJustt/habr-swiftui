//
//  myAttrString.swift
//  myAttrString
//
//  Created by Anton Krivonozhenkov on 05.08.2021.
//

import SwiftUI

struct myAttrString: View {
    var paragraph: String
    var body: some View {
        comment2Text(paragraph: paragraph)
    }
}

func comment2Text(paragraph: String) -> some View {
    var str: String
    
    str = paragraph.replacingOccurrences(of: "<br>", with: "\n")
    str = str.replacingOccurrences(of: "</p><p>", with: "\n")
    str = str.replacingOccurrences(of: "<p>", with: "")
    str = str.replacingOccurrences(of: "</p>", with: "")
    str = str.replacingOccurrences(of: "</a>", with: "</ahref>")
    str = str.replacingOccurrences(of: "<div xmlns=\"http://www.w3.org/1999/xhtml\">", with: "")
     str.removeFirst()
    str.removeLast()
    str.removeLast()
    str.removeLast()
    str.removeLast()
    str.removeLast()
    str.removeLast()
       str.removeLast()
    
    //  str = ""
    
    // <code> - ode>
    // <blockquote> - ockquote>
    // <figure> - gure>
    // <details - tails>
    // <a href= - ref>
    
    let words = str.components(separatedBy: ["<code>", "<blockquote>", "ode>", "ockquote>", "<figure>", "gure>", "<details", "tails>", "<a href=", "ref>"])
    
    //    for word in words {
    //        print(word)
    //        str = word.replacingOccurrences(of: "<div xmlns=\"http://www.w3.org/1999/xhtml\">", with: "")
    //        str = str.replacingOccurrences(of: "<br>", with: "\n")
    //        str = str.replacingOccurrences(of: "</p><p>", with: "\n")
    //        str = str.replacingOccurrences(of: "<p>", with: "")
    //        str = str.replacingOccurrences(of: "</p>", with: "")
    //        str.removeFirst()
    //        str.removeLast()
    //            str.removeLast()
    //            str.removeLast()
    //            str.removeLast()
    //            str.removeLast()
    //            str.removeLast()
    //        str.removeLast()
    //        print(str)
    //    }
    //
    //    var resultView: some View {
    //        VStack {
    //            Text(str)
    //        }
    //    }
    
    var resultView: some View {
        VStack(alignment: .leading) {
            ForEach(words.indices, id: \.self) { index in
                if (words[index].count > 0) && (words[index] != " ") {
                    switch words[index] {
                        
                        // CODE
                    case _ where words[index].contains("</c"):
                        Text(words[index].replacingOccurrences(of: "</c", with: ""))
                            .font(.system(.body, design: .monospaced))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Rectangle()
                                    .fill(Color("AccentColor"))
                                    .opacity(0.1)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color("AccentColor"), lineWidth: 2)
                                    )
                            )
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                        
                        // BLOCKQUOTE
                    case _ where words[index].contains("</bl"):
                        HStack {
                            Rectangle().fill(Color("AccentColor")).frame(width: 3)
                            Text(cleaning(s: words[index]))
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        //   .padding()
                        
                        // IMAGE
                    case _ where words[index].contains("</fi"):
                        Text("img")
                        
                        // LINK
                    case _ where words[index].contains("</ah"):
                        HStack {
                          //  Text(words[index])
                            Link(linking(s: words[index]), destination: (URL(string: "m.habr.com") ?? URL(string: "https://m.habr.com"))!)
                                Image(systemName: "arrow.up.right.square")
                        }
                        
                        // SPOILER
                    case _ where words[index].contains("</de"):
                        GroupBox () {
                            DisclosureGroup(spoilering(s: words[index])) {
                                VStack {
                                    Text(words[index])
                                }
                            }.foregroundColor(Color("FeedListFont"))
                        }
                        
                        
                    default:
                        Text(cleaning2(s: words[index]))
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    } }
            }
        }
        // .padding()
    }
    
    return resultView
}

func cleaning(s:String) -> String {
    var returnS: String
    returnS = ""
    returnS = s.replacingOccurrences(of: "</bl", with: "")
    
    // returnS.removeFirst()
    returnS.removeLast()
    returnS.removeLast()
    
    let index = returnS.index(returnS.startIndex, offsetBy: 1)
    if returnS[index] == " " {
        returnS.removeFirst()
        print("removed")
    }
    //
//    let index2 = returnS.index(returnS.startIndex, offsetBy: 1)
//    if returnS[index2] == " " {
//        returnS.removeFirst()
//        print("removed")
//    }
//    //
//    let index3 = returnS.index(returnS.startIndex, offsetBy: 1)
//    if returnS[index3] == " " {
//        returnS.removeFirst()
//        print("removed")
//    }
    
    print(returnS)
    return returnS
}

func cleaning2(s:String) -> String {
    var returnS: String
    returnS = ""
    returnS = s
    // returnS.removeFirst()
    
    //    let index = returnS.index(returnS.startIndex, offsetBy: 1)
    //    if returnS[index] == " " {
    //        returnS.removeFirst()
    //    }
    //
    //    let index2 = returnS.index(returnS.startIndex, offsetBy: 1)
    //    if returnS[index2] == " " {
    //        returnS.removeFirst()
    //    }
    
    return returnS
}

func spoilering(s:String) -> String {
    var returnS: String
    returnS = ""
    returnS = s
    
//    let words = s.components(separatedBy: ["<summary>", "</summary>"])
//    returnS = words[1]
    
    if (returnS == "") || (returnS == " ") {
        returnS = "spoiler"
    }
    
    return returnS
}

func linking(s:String) -> String {
    var returnS: String
    returnS = ""
    returnS = s
    
    let words = s.components(separatedBy: ["\">", "</ah"])
    returnS = words[1]
    
    if (returnS == "") || (returnS == " ") {
        returnS = "link"
    }
    
    return returnS
}

extension String {
    func components<T>(separatedBy separators: [T]) -> [String] where T : StringProtocol {
        var result = [self]
        for separator in separators {
            result = result
                .map { $0.components(separatedBy: separator) }
                .flatMap { $0 }
        }
        return result
    }
}

struct myAttrString_Previews: PreviewProvider {
    static var previews: some View {
        myAttrString(paragraph: "1234567890<blockquote>Пазл с  поддерживаемой iOS 15, кажется, сложился</blockquote>Да как-то не особо. Ничего не мешало этот тред пул поставлять как библиотеку для старых iOS.<br>Выглядит все прям под копирку с C#. <code>.font(.system(.body, design: .monospaced))<br>.padding(.horizontal, 10)<br>.padding(.vertical, 5)</code>Особенно с этими всеми контекстами и тасками. <br><br>Там свифт пытается быть безопасными наподобие раста.<figure><img src=\"https://habr.com/img.png\"></figure>Text<br>Text<details class=\"spoiler\"><summary>Хорошо показал себя зимой</summary>Текст спойлера</details><a href=\"https://habr.com/ru/company/madrobots/profile/\" rel=\"noopener noreferrer nofollow\">Madrobots</a></div>")
            .padding()
    }
}
