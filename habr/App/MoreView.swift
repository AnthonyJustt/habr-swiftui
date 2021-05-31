//
//  moreView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 03.05.2021.
//

import SwiftUI

struct moreView: View {
    @State private var tabSelection = 4
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(
                        destination: FeedView(farray: [], fNewsArray: [], viewName: "Habr  —  Песочница", showingNews: false, httpsAddress: "https://m.habr.com/ru/sandbox/invited/", tabSelection: $tabSelection)) {
                        SectionView(image: "pencil.and.outline", label: "Песочница")
                    }
                    Spacer()
                    NavigationLink(destination: UserView()) {
                        SectionView(image: "person.icloud", label: "Профиль")
                    }
                    Spacer()
                    NavigationLink(destination: AboutHabr()) {
                        SectionView(image: "h.square.fill", label: "О Хабре")
                    }
                }.padding()
                HStack {
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        SectionView(image: "gear", label: "Настройки")
                    }
                    Spacer()
                    NavigationLink(destination: EmptyView()) {
                    SectionView(image: "info.circle", label: "О программе")
                    // not implemented yet
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct SectionView: View {
    var image: String = ""
    var label: String = ""
    var body: some View {
        VStack {
            Image(systemName: image)
                .font(.largeTitle)
            Text(label)
        }
    }
}

struct moreView_Previews: PreviewProvider {
    static var previews: some View {
        moreView()
    }
}
