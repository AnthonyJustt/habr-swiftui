//
//  AuthorView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 01.05.2021.
//

import SwiftUI

struct AuthorView: View {
    @State var farray = AuthorItem(card_name: "", card_nickname: "", short_info: "", karma: "", rating: "")
    @State var infoDict: [(key: String, value: String)] = []
    @State var isHidden: Bool = true
    var title: String // не используется, но в нем логин автора из главного вида
    var link: String
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    //     Image("EmptyImage")
                    //         .resizable()
                    Color.white
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 110, height: 110, alignment: .center)
                        )
                        .background(
                            Circle()
                                .fill(Color("AccentColor"))
                                .frame(width: 120, height: 120, alignment: .center)
                        )
                        .padding()
                    
                    Text(farray.card_nickname)
                        .font(.system(.title2))
                        .foregroundColor(Color("FeedListFont"))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    if !farray.card_name.isEmpty {
                        Text("aka \(farray.card_name)")
                    }
                    if !farray.short_info.isEmpty {
                        Text(farray.short_info)
                    }
                }
                .padding()
                
                HStack {
                    VStack(alignment: .center, spacing: 0) {
                        if farray.karma == "0" {
                            Text(farray.karma)
                                .font(.system(.largeTitle))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        if (Double(farray.karma) ?? 0) > 0 {
                            Text(farray.karma)
                                .font(.system(.largeTitle))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        if (Double(farray.karma) ?? 0) < 0 {
                            Text(farray.karma)
                                .font(.system(.largeTitle))
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        Text("Карма")
                            .font(.system(.body))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(width: 180)
                    Divider()
                    VStack(alignment: .center, spacing: 0) {
                        Text(farray.rating)
                            .font(.system(.largeTitle))
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                        Text("Рейтинг")
                            .font(.system(.body))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(width: 180)
                }
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Информация".uppercased())
                        .font(.headline)
                        .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(infoDict.indices, id: \.self) { index in
                            HStack {
                                Text(infoDict[index].key).foregroundColor(Color.gray)
                                Spacer()
                                Text(infoDict[index].value)
                            }
                            .padding(.horizontal)
                            .frame(height:50)
                            if index != infoDict.count - 1 {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    .cornerRadius(10)
                    .padding()
                }
                
                Text("https://habr.com\(link)")
                    .font(.footnote)
            }
            .opacity(isHidden ? 0 : 1)
            
            ProgressView()
                .opacity(isHidden ? 1 : 0)
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear(perform: {
                    DispatchQueue.global(qos: .userInitiated).async {
                        print("https://m.habr.com\(link)")
                        (farray, infoDict) = fparseAuthor(fhtml: fname(furl: "https://m.habr.com\(link)"))
                        isHidden.toggle()
                    }
                })
        }
    }
}

struct AuthorView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorView(farray: AuthorItem(card_name: "Имя Фамилия_", card_nickname: "Login_", short_info: "short info text_", karma: "123.4", rating: "567,8"), title: "@Author_", link: "")
    }
}
