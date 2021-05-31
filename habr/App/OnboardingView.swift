//
//  OnboardingView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        VStack(alignment: .center) {
            Capsule()
                .frame(width: 120, height: 6)
                .foregroundColor(Color.secondary)
                .opacity(0.2)
                .padding()
            Spacer()
            TitleView()
            VStack(alignment: .leading) {
                InformationDetailView(title: "Лента и новости", subTitle: "Список публикаций, которые были написаны за последние сутки", imageName: "house")
                
                InformationDetailView(title: "Список чтения", subTitle: "Сохранённые публикации, чтобы прочесть их позже", imageName: "eyeglasses")
                
                InformationDetailView(title: "Профиль", subTitle: "Список публикаций, закладок, собственная лента по интересам", imageName: "person.icloud")
            }
            .padding(.horizontal)
            Spacer()
            Button(action: {
                isOnboarding = false
            }) {
                Text("Начать")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(Color("AccentColor"))
                    )
                    .padding(.bottom)
            }
            .padding(.horizontal)
        }
    }
}

struct TitleView: View {
    var body: some View {
        VStack {
            Image("onBoardingImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, alignment: .center)
                .accessibility(hidden: true)
            
            Text("Добро пожаловать")
                .fontWeight(.black)
                .font(.system(size: 36))
            
            Text("Хабр")
                .fontWeight(.black)
                .font(.system(size: 36))
                .foregroundColor(Color("AccentColor"))
        }
    }
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(Color("FeedListFont"))
                .padding()
                .accessibility(hidden: true)
                .frame(width: 70)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
