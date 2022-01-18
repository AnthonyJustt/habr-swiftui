//
//  ReadingListView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 28.03.2021.
//

import SwiftUI
import CoreData

struct ReadingListView: View {
    
    @State private var selection = Set<Entity>()
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entity.dateAdded, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Entity>
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    @State var isEditing = false
    
    var body: some View {
        NavigationView {

            List(selection: $selection) {
                ForEach(
                    items.filter {
                        searchBar.text.isEmpty || ($0.title?.lowercased().contains(searchBar.text.lowercased()))!
                    },
                    id: \.self
                ) { item in
                    NavigationLink (destination: FeedDetailView(
                        title: item.title!,
                        link: item.link ?? "???",
                        comments: item.comments ?? "???"
                    )) {
                        Text(item.title!)
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteItems(offsets: indexSet)
                })
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
            
            .navigationTitle(LocalizedStringKey("ReadingList.Title"))
//             .addSearchBar(self.searchBar)
            .navigationBarItems(trailing: EditButton())
//            .navigationBarItems(trailing:
//                                    Button(action: {
//                self.isEditing.toggle()
//            }) {
//                Text(isEditing ? "Done" : "Edit")
//            })
//
            
            Text("")
                .modifier(ConditionalModifier(isBold: isEditing))
            
            if items.count == 0 {
                EmptyPlaceholderView(imageName: "EmptyImage", rendering: true)
                    .padding()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ConditionalModifier: ViewModifier {
    var isBold: Bool
    func body(content: Content) -> some View {
        Group {
            if self.isBold {
                content
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Select all")
                            })
                            Spacer()
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Delete")
                            })
                        }
                    }
            }
        }
    }
}

struct ReadingListView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
