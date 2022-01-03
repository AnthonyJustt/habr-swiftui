//
//  OnboardingView_15.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 04.08.2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct OnboardingView_15: View {
    var body: some View {
        Home()
    }
}

@available(iOS 15.0, *)
struct OnboardingView_15_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView_15()
            .preferredColorScheme(.dark)
        OnboardingView_15()
            .preferredColorScheme(.light)
    }
}

struct customCircle: View {
    var nameColor: String
    var blurRadius: CGFloat
    var offsetX: CGFloat
    var offsetY: CGFloat
    var body: some View {
        Circle()
            .fill(Color(nameColor))
            .blur(radius: blurRadius)
            .offset(x: offsetX, y: offsetY)
    }
}

@available(iOS 15.0, *)
struct Home: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("BG1"), Color("BG2")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            GeometryReader{ proxy in
                let size = proxy.size
                
                Color.black
                    .opacity(0.7)
                    .blur(radius: 200)
                    .ignoresSafeArea()
                
                customCircle(nameColor: "Purple", blurRadius: 100, offsetX: -size.width / 1.8, offsetY: -size.height / 5)
                    .padding(50)
                
                customCircle(nameColor: "LightBlue", blurRadius: 100, offsetX: size.width / 1.8, offsetY:  -size.height / 2)
                    .padding(50)
                
                customCircle(nameColor: "LightBlue", blurRadius: 90, offsetX: size.width / 1.8, offsetY:  size.height / 2)
                    .padding(50)
                
                Circle()
                    .fill(Color("Purple"))
                    .padding(100)
                    .blur(radius: 110)
                    .offset(x: size.width / 1.8, y: size.height / 2)
                Circle()
                    .fill(Color("Purple"))
                    .padding(100)
                    .blur(radius: 110)
                    .offset(x: -size.width / 1.8, y: size.height / 2)
            }
            
            VStack {
                Spacer(minLength: 10)
                
                ZStack {
                    Circle()
                        .fill(Color("Purple"))
                        .blur(radius: 20)
                        .frame(width: 100, height: 100)
                        .offset(x: 120, y: -80)
                    Circle()
                        .fill(Color("LightBlue"))
                        .blur(radius: 40)
                        .frame(width: 100, height: 100)
                        .offset(x: -120, y: 100)
                    
                    GlassMorphicCard()
                }
                
                Spacer(minLength: 10)
                
                Text("Onboard.welcome")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color("OnboardText"))
                
                VStack(alignment: .leading) {
                    InformationDetailView(title: "Onboard.FeedandNews", subTitle: "Onboard.FeedandNewsText", imageName: "house", primaryColor: "OnboardText")
                    
                    InformationDetailView(title: "Onboard.ReadingList", subTitle: "Onboard.ReadingListText", imageName: "eyeglasses", primaryColor: "OnboardText")
                }
                
                Button(action: {
                    isOnboarding = false
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("AccentColor"))
                            .opacity(0.1)
                            .background(
                                Color("AccentColor")
                                    .opacity(0.08)
                                    .blur(radius: 10)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("OnboardText"), lineWidth: 2)
                                    .padding(2)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                        Text("Onboard.getstarted")
                            .font(.title3.bold())
                            .foregroundColor(Color("OnboardText"))
                    }
                    .frame(width: 200, height: 55)
                }
                .padding(.horizontal)
                .padding(.horizontal, 50)
                .padding(.vertical, 20)
            }
            .padding()
        }
    }
    
    func getAttributedString(str1: String, str2: String) -> AttributedString {
        var attStr = AttributedString(str1)
        attStr.foregroundColor = .gray
        
        if let range = attStr.range(of: str2){
            attStr[range].foregroundColor = .white
        }
        
        return attStr
    }
}

struct GlassMorphicCard: View {
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .opacity(0.1)
                .background(
                    Color.white
                        .opacity(0.08)
                        .blur(radius: 10)
                )
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            .linearGradient(.init(colors:
                                                    [Color("Purple"),
                                                     Color("Purple").opacity(0.5),
                                                     .clear,
                                                     .clear,
                                                     Color("LightBlue")]),
                                            startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5)
                        .padding(2)
                )
                .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
            
            VStack {
                Image("habr_logo_white")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, alignment: .center)
                    .foregroundColor(Color("OnboardText"))
                    .accessibility(hidden: true)
                
                Text("Onboard.habr")
                    .kerning(2)
                    .font(.system(size: 85, weight: .bold))
                    .foregroundColor(Color("OnboardText"))
                    .padding(.top, 2)
                
                Text("mobile")
                    .font(.title2)
                    .foregroundColor(Color.white.opacity(0.4))
            }
        }
        .frame(width: width / 1.5, height: 270)
    }
}

struct blurView: UIViewRepresentable {
    
    var cornerRadius: CGFloat = 0
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.layer.cornerRadius = cornerRadius
        uiView.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .light)
        uiView.effect = blurEffect
        
        //        uiView.translatesAutoresizingMaskIntoConstraints = false
        //        uiView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        //        uiView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
}
