//
//  OnboardingView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import SwiftUI

struct OnboardingView_14: View {
    
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
                InformationDetailView(title: "Onboard.FeedandNews", subTitle: "Onboard.FeedandNewsText", imageName: "house", primaryColor: "FeedListFont")
                
                InformationDetailView(title: "Onboard.ReadingList", subTitle: "Onboard.ReadingListText", imageName: "eyeglasses", primaryColor: "FeedListFont")
                
                InformationDetailView(title: "Onboard.Profile", subTitle: "Onboard.ProfileText", imageName: "person.icloud", primaryColor: "FeedListFont")
            }
            .padding(.horizontal)
            Spacer()
            Button(action: {
                isOnboarding = false
            }) {
                Text("Onboard.getstarted")
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
            Image("habr_logo_white")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, alignment: .center)
                .foregroundColor(Color("AccentColor"))
                .accessibility(hidden: true)
            
            Text(LocalizedStringKey("Onboard.welcome"))
             //   .fontWeight(.black)
                .font(.system(size: 36))
            
            Text(LocalizedStringKey("Onboard.habr"))
                .fontWeight(.semibold)
                .font(.system(size: 60))
                .foregroundColor(Color("AccentColor"))
        }
    }
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"
    var primaryColor: String
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
//                .foregroundColor(Color("FeedListFont"))
                .foregroundColor(Color(primaryColor))
                .padding()
                .accessibility(hidden: true)
                .frame(width: 70)
            
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(title))
                    .font(.headline)
                   // .foregroundColor(.primary)
                    .foregroundColor(Color(primaryColor))
                    .fontWeight(.semibold)
                
                Text(LocalizedStringKey(subTitle))
                    .font(.body)
                    .foregroundColor(Color(primaryColor))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView_14()
            .preferredColorScheme(.dark)
        OnboardingView_14()
            .preferredColorScheme(.light)
    }
}
