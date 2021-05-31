//
//  SettingsView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isOnboarding") var isOnboarding: Bool = false
    @State private var buttonCache = LocalizedStringKey("Calc.current.cache.size")
    @State private var buttonCacheSize: String = ""
    
    var appLang = ["Русский", "English"]
    @State private var selectedAppLang = "Русский"
    var contentLang = ["Русский", "Английский", "Все"]
    @State private var selectedContentLang = "Русский"
    
    var body: some View {
        Form {
            Section(header: Text(LocalizedStringKey("Language.Settings"))) {
                Picker(LocalizedStringKey("Interface.Language"), selection: $selectedAppLang) {
                    ForEach(appLang, id: \.self) {
                        Text($0)
                    }
                }
                Picker(LocalizedStringKey("Content.Language"), selection: $selectedContentLang) {
                    ForEach(contentLang, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Section(header: Text(LocalizedStringKey("iPhone.Storage"))) {
                HStack {
                    Button(action: {
                            DispatchQueue.global(qos: .userInitiated).async {
                                do {
                                    
                                    let size: Float = Float(try FileManager.default.allocatedSizeOfDirectory(at: getDocumentsDirectory())) / 1024 / 1024
                                    print(String(format: "%.1f", size))
                                    print(getDocumentsDirectory())
                                    buttonCache = LocalizedStringKey("Cache.size.is")
                                    buttonCacheSize = "\(String(format: "%.1f", size)) MB"
                                    
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }}, label: {
                                Text(buttonCache)
                                    .foregroundColor(.black)
                            })
                    Spacer()
                    Text(buttonCacheSize)
                        .foregroundColor(.gray)
                }
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        Text(LocalizedStringKey("Clear.cache"))
                            .foregroundColor(.red)
                    })
                    Spacer()
                }
            }
            
            Section(header: Text(LocalizedStringKey("General.Settings")), footer: Text(LocalizedStringKey("Reset.all.explain"))) {
                Toggle(isOn: $isOnboarding) {
                    if isOnboarding {
                        Text("Сброшено!")
                    } else {
                        Text(LocalizedStringKey("Reset.all"))
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(LocalizedStringKey("Settings.Title"), displayMode: .large)
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.locale, .init(identifier: "en"))
    }
}
