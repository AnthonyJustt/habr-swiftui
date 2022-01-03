//
//  DisclosureView.swift
//  DisclosureView
//
//  Created by Anton Krivonozhenkov on 07.08.2021.
//

import SwiftUI

struct DisclosureView: View {
    var hubArray: [feedTagsItem]
    var tagArray: [feedTagsItem]
    var labelArray: [feedTagsItem]
    var originalArray: [feedTagsItem]
    
    var body: some View {
        GroupBox () {
            DisclosureGroup (LocalizedStringKey("Disclosure.HubsTags")) {
                VStack(alignment: .leading) {
                    Text(LocalizedStringKey("Disclosure.Hubs")).bold()
                        .padding(.top)
                        .padding(.bottom, 4)
                    ForEach(hubArray, id: \.id) {
                        item in
                        NavigationLink(destination: EmptyView()) {
                            tagView(title: item.title)
                        }
                    }
                    
                    Text(LocalizedStringKey("Disclosure.Tags")).bold()
                        .padding(.top)
                        .padding(.bottom, 4)
                    ForEach(tagArray, id: \.id) {
                        item in
                        NavigationLink(destination: EmptyView()) {
                            tagView(title: item.title)
                        }
                    }
                    
                    ForEach(labelArray, id: \.id) {
                        item in labelView(title: item.title)
                    }
                    
                    ForEach(originalArray, id: \.id) {
                        item in buttonOriginalView(author: item.title)
                    }
                }
            }.foregroundColor(Color("FeedListFont"))
        }
    }
}

struct DisclosureView_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureView(hubArray: [feedTagsItem(title: "title_hub", link: "link"), feedTagsItem(title: "title_hub", link: "link"), feedTagsItem(title: "title_hub", link: "link")], tagArray: [feedTagsItem(title: "title_tag", link: "link"), feedTagsItem(title: "title_hub", link: "link"), feedTagsItem(title: "title_hub", link: "link"), feedTagsItem(title: "title_hub", link: "link")], labelArray: [feedTagsItem(title: "title_label", link: "")], originalArray: [feedTagsItem(title: "title_original", link: "")])
        //    .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
