//
//  parallaxView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 08.04.2021.
//

import SwiftUI

struct parallaxView: View {
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
            geometry.frame(in: .global).minY
        }
        
        // 2
        private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
            let offset = getScrollOffset(geometry)
            
            // Image was pulled down
            if offset > 0 {
                return -offset
            }
            
            return 0
        }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }
    
    private func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        // 2
        let offset = geometry.frame(in: .global).maxY

        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // 3 (values will range from 0 - 1)
        return blur * 6 // Values will range from 0 - 6
    }
    
    var body: some View {
        // 1
        ScrollView {
            
            GeometryReader { geometry in
                Image("Placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry)) // 2
                    .blur(radius: self.getBlurRadiusForImage(geometry)) // 4
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry)) // 3
            }.frame(height: 300)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    
                    // 2
                    Image("EmptyImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                      //  .shadow(radius: 4)
                    
                    // 3
                    VStack(alignment: .leading) {
                        Text("Article Written By")
                            .font(.custom("Avenir Next", size: 12))
                            .foregroundColor(.gray)
                        Text("Brandon Baars")
                            .font(.custom("Avenir Next", size: 17))
                    }
                }
                Text("02 January 2019 • 5 min read")
                    // .font(.avenirNextRegular(size: 12))
                    .foregroundColor(.gray)
                
                Text("How to build a parallax scroll view")
                // .font(.avenirNext(size: 28))
                
                Text(loremIpsum)
                    .lineLimit(nil)
                // .font(.avenirNextRegular(size: 17))
                // 3
            }.padding(.horizontal)
            .padding(.top, 16.0) // 2
        }.edgesIgnoringSafeArea(.all) // 3
    }
}

struct parallaxView_Previews: PreviewProvider {
    static var previews: some View {
        parallaxView()
    }
}

let loremIpsum = """
Lorem ipsum dolor sit amet consectetur adipiscing elit donec, gravida commodo hac non mattis augue duis vitae inceptos, laoreet taciti at vehicula cum arcu dictum. Cras netus vivamus sociis pulvinar est erat, quisque imperdiet velit a justo maecenas, pretium gravida ut himenaeos nam. Tellus quis libero sociis class nec hendrerit, id proin facilisis praesent bibendum vehicula tristique, fringilla augue vitae primis turpis.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
"""
