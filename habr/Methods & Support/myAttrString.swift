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
    
    let words = str.components(separatedBy: ["<code>", "<blockquote>", "ode>", "ockquote>", "<figure>", "gure>"])
    
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
        VStack {
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
                                    .fill(Color.pink)
                                    .opacity(0.05)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.red)
                                    )
                            )
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                        
                        // BLOCKQUOTE
                    case _ where words[index].contains("</bl"):
                        HStack {
                            Rectangle().fill(Color.green).frame(width: 2)
                            Text(cleaning(s: words[index]))
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                     //   .padding()
                        
                        // IMAGE
                    case _ where words[index].contains("</fi"):
                        Text("img")
                        
                        
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

    returnS.removeFirst()
    returnS.removeLast()
    returnS.removeLast()
    
    let index = returnS.index(returnS.startIndex, offsetBy: 1)
    if returnS[index] == " " {
        returnS.removeFirst()
        print("removed")
    }
    
    let index2 = returnS.index(returnS.startIndex, offsetBy: 1)
    if returnS[index2] == " " {
        returnS.removeFirst()
        print("removed")
    }
    
    let index3 = returnS.index(returnS.startIndex, offsetBy: 1)
    if returnS[index3] == " " {
        returnS.removeFirst()
        print("removed")
    }

    print(returnS)
    return returnS
}

func cleaning2(s:String) -> String {
    var returnS: String
    returnS = ""
    returnS = s
    returnS.removeFirst()
    
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
        myAttrString(paragraph: "<blockquote>Пазл с минимальной поддерживаемой iOS 15, кажется, сложился</blockquote>Да как-то не особо. Ничего не мешало этот тред пул поставлять как библиотеку для старых iOS. Можно посмотреть на C#, где подобная практика повсеместна. Это ведь всего лишь тред пул, которому явно ничего хитрого не надо от самой iOS. <br>Выглядит все прям под копирку с C#. <code>.font(.system(.body, design: .monospaced))<br>.padding(.horizontal, 10)<br>.padding(.vertical, 5)</code>Особенно с этими всеми контекстами и тасками. Не сказать, что рад видеть очередные асинки, но наверное лучше, чем ничего. И в этом плане более интересны как раз акторы.<br><br>Там свифт пытается быть безопасными наподобие раста.<figure><img src=\"https://habr.com/img.png\"></figure>Text<br>Text</div>")
    }
}
