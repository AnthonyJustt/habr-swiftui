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
                        destination: FeedView(farray: [], fNewsArray: [], viewName: "More.SandboxTitle", showingNews: false, httpsAddress: "https://m.habr.com/ru/sandbox/invited/", tabSelection: $tabSelection)) {
                        SectionView(image: "pencil.and.outline", label: "More.Sandbox")
                    }
                    Spacer()
                    NavigationLink(destination: UserView()) {
                        SectionView(image: "person.icloud", label: "More.Profile")
                    }
                    Spacer()
                    NavigationLink(destination: AboutHabr()) {
                        SectionView(image: "h.square.fill", label: "More.AboutHabr")
                    }
                }.padding()
                HStack {
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        SectionView(image: "gear", label: "More.Settings")
                    }
                    Spacer()
                    NavigationLink(destination: AboutApp()) {
                    SectionView(image: "info.circle", label: "More.AboutApp")
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
            Text(LocalizedStringKey(label))
        }
    }
}

struct moreView_Previews: PreviewProvider {
    static var previews: some View {
        moreView()
    }
}
