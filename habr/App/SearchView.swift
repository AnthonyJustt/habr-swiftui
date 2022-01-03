//
//  SearchView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 26.04.2021.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchString = ""
    @State var farray: [FeedListItem]
    @State var showToast: Bool =  false
    @State var searchTextNothing: String = ""
    
    @State var toggleOpacity: Bool = false
    
    func search() {
        DispatchQueue.global(qos: .userInitiated).async {
//            isHidden.toggle()
//            isHidden_.toggle()
            farray.removeAll()
            searchString = "https://habr.com/ru/search/?q=" + searchString + "&target_type=posts&order=relevance"
            print(searchString)
            farray = fparse(fhtml: fname(furl: searchString))
            searchTextNothing = "Ничего не найдено"
//            isHidden_.toggle()
//            isHidden.toggle()
        }
    }
    func cancel() {
        searchString = ""
    }
    
    @State private var selectedMenuItem = "Search.byPosts"
    var menuItems: [String] = ["Search.byPosts", "Search.byHubs", "Search.byUsers", "Search.byComments"]
    
    @State private var selectedColorIndex = 0
    
//    @State var isHidden: Bool = true
//    @State var isHidden_: Bool = true
    
    var body: some View {
        SearchNavigation(text: $searchString, search: search, cancel: cancel) {
            
            ZStack {
                ScrollView(.vertical, showsIndicators: true) {
                    
                    Picker("Favorite Color", selection: $selectedColorIndex, content: {
                                    Text("Релевантные").tag(0)
                                    Text("По времени").tag(1)
                                    Text("По рейтингу").tag(2)
                                })
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal)
                    
                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(farray.indices, id: \.self) { index in
                            NavigationLink (destination: FeedDetailView(
                                title: farray[index].title,
                                link: farray[index].link,
                                comments: farray[index].comments
                            )) {
                                FeedListItemView(feedListItem: farray[index], showToast: $showToast)
                            }
                        }
                    }
                    if farray.count == 0 {
                        Text(searchTextNothing)
                            .padding()
                    }
                }
//                .opacity(isHidden_ ? 0 : 1)
                .navigationTitle(LocalizedStringKey("Search.Title"))
                .navigationBarItems(trailing:
                                        Menu {
                                            ForEach(menuItems, id: \.self) {
                                                index in
                                                Button(action: {
                                                    selectedMenuItem = "\(index)"
                                                }, label: {
                                                    if selectedMenuItem == index{
                                                        HStack {
                                                            Text(LocalizedStringKey(index))
                                                            Image(systemName: "checkmark")
                                                        }} else {
                                                            Text(LocalizedStringKey(index))
                                                        }
                                                })
                                            }
                                        }
                                        label: {
                                            Label("", systemImage: "ellipsis.circle")
                                                .font(.title2)
                                    }
                                        .onTapGesture {
                    toggleOpacity.toggle()
                }
                )
           
//                ProgressView()
//                    .opacity(isHidden ? 0 : 1)
//                    .progressViewStyle(CircularProgressViewStyle())
            
            }
        }
        .edgesIgnoringSafeArea(.top)
        
        .overlay(
            blurView(cornerRadius: 0)
                .opacity(toggleOpacity ? 0.5 : 0)
                .onTapGesture{
                    toggleOpacity.toggle()
                }
        )
    }
}

struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var search: () -> Void
    var cancel: () -> Void
    var content: () -> Content
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text, searchAction: search, cancelAction: cancel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)
        var search: () -> Void
        var cancel: () -> Void
        
        init(content: Content, searchText: Binding<String>, searchAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController
            
            _text = searchText
            search = searchAction
            cancel = cancelAction
        }
        
        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            search()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static let fli: [ FeedListItem ] = [FeedListItem(
        title: "Заголовок_",
        author: "Автор_",
        author_link: "",
        date: "сегодня в 00:00_",
        rate: "3",
        rate_detail: "",
        view: "1234_",
        bookmark: "5678_",
        comments: "9999",
        link: "",
        article_snippet: "",
        offset: 0,
        isSwiped: false
    ) ]
    static var previews: some View {
        SearchView(farray: fli)
    }
}
