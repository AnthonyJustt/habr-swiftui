//
//  PullToRefreshView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 05.05.2021.
//

import SwiftUI

struct RefreshControl: View {
    // https://prafullkumar77.medium.com/how-to-making-pure-swiftui-pull-to-refresh-b497d3639ee5
    var coordinateSpace: CoordinateSpace
    var onRefresh: ()->Void
    @State var refresh: Bool = false
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: coordinateSpace).midY > 50) {
                Spacer()
                    .onAppear {
                        if refresh == false {
                            onRefresh() // call refresh once if pulled more than 50px
                        }
                        refresh = true
                    }
            } else if (geo.frame(in: coordinateSpace).maxY < 1) {
                Spacer()
                    .onAppear {
                        refresh = false
                        // reset  refresh if view shrink back
                    }
            }
            ZStack(alignment: .center) {
                if refresh { // show loading if refresh called
                    ProgressView()
                } else { // mimic static progress bar with filled bar to the drag percentage
                    ForEach(0..<8) { tick in
                        VStack {
                            Rectangle()
                                .fill(Color(UIColor.tertiaryLabel))
                                .opacity((Int((geo.frame(in: coordinateSpace).midY)/7) < tick) ? 0 : 1)
                                .frame(width: 3, height: 7)
                                .cornerRadius(3)
                            Spacer()
                        }
                        .rotationEffect(Angle.degrees(Double(tick)/(8) * 360))
                    }
                    .frame(width: 20, height: 20, alignment: .center)
                }
            }
            .frame(width: geo.size.width)
        }
        .padding(.top, -100)
    }
}

//struct PullToRefreshView: View
//{
// https://stackoverflow.com/a/66107687/2715636
//    private static let minRefreshTimeInterval = TimeInterval(0.1)
//    private static let triggerHeight = CGFloat(200)
//    private static let indicatorHeight = CGFloat(200)
//    private static let fullHeight = triggerHeight + indicatorHeight
//
//    let backgroundColor: Color
//    let foregroundColor: Color
//    let isEnabled: Bool
//    let onRefresh: () -> Void
//
//    @State private var isRefreshIndicatorVisible = false
//    @State private var refreshStartTime: Date? = nil
//
//    init(bg: Color = .white, fg: Color = .black, isEnabled: Bool = true, onRefresh: @escaping () -> Void)
//    {
//        self.backgroundColor = bg
//        self.foregroundColor = fg
//        self.isEnabled = isEnabled
//        self.onRefresh = onRefresh
//    }
//
//    var body: some View
//    {
//        VStack(spacing: 0)
//        {
//            LazyVStack(spacing: 0)
//            {
//                Color.clear
//                    .frame(height: Self.triggerHeight)
//                    .onAppear
//                    {
//                        if isEnabled
//                        {
//                            withAnimation
//                            {
//                                isRefreshIndicatorVisible = true
//                            }
//                            refreshStartTime = Date()
//                        }
//                    }
//                    .onDisappear
//                    {
//                        if isEnabled, isRefreshIndicatorVisible, let diff = refreshStartTime?.distance(to: Date()), diff > Self.minRefreshTimeInterval
//                        {
//                            onRefresh()
//                        }
//                        withAnimation
//                        {
//                            isRefreshIndicatorVisible = false
//                        }
//                        refreshStartTime = nil
//                    }
//            }
//            .frame(height: Self.triggerHeight)
//
//            indicator
//                .frame(height: Self.indicatorHeight)
//        }
//        .background(backgroundColor)
//        .ignoresSafeArea(edges: .all)
//        .frame(height: Self.fullHeight)
//        .padding(.top, -Self.fullHeight)
//    }
//
//    private var indicator: some View
//    {
//        ProgressView()
//            .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
//            .opacity(isRefreshIndicatorVisible ? 1 : 0)
//    }
//}
