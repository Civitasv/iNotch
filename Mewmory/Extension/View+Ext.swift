//
//  View+CornerRadius.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/18.
//

import SwiftUI
import Foundation
import Combine

struct RectCorner: OptionSet {
    let rawValue: Int
    static let topLeft = RectCorner(rawValue: 1 << 0)
    static let topRight = RectCorner(rawValue: 1 << 1)
    static let bottomRight = RectCorner(rawValue: 1 << 2)
    static let bottomLeft = RectCorner(rawValue: 1 << 3)
    static let allCorners: RectCorner = [.topLeft, topRight, .bottomLeft, .bottomRight]
}

// draws shape with specified rounded corners applying corner radius
struct RoundedCornersShape: Shape {
    var radius: CGFloat = .zero
    var corners: RectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let p1 = CGPoint(x: rect.minX, y: corners.contains(.topLeft) ? rect.minY + radius  : rect.minY )
        let p2 = CGPoint(x: corners.contains(.topLeft) ? rect.minX + radius : rect.minX, y: rect.minY )

        let p3 = CGPoint(x: corners.contains(.topRight) ? rect.maxX - radius : rect.maxX, y: rect.minY )
        let p4 = CGPoint(x: rect.maxX, y: corners.contains(.topRight) ? rect.minY + radius  : rect.minY )

        let p5 = CGPoint(x: rect.maxX, y: corners.contains(.bottomRight) ? rect.maxY - radius : rect.maxY )
        let p6 = CGPoint(x: corners.contains(.bottomRight) ? rect.maxX - radius : rect.maxX, y: rect.maxY )

        let p7 = CGPoint(x: corners.contains(.bottomLeft) ? rect.minX + radius : rect.minX, y: rect.maxY )
        let p8 = CGPoint(x: rect.minX, y: corners.contains(.bottomLeft) ? rect.maxY - radius : rect.maxY )

        
        path.move(to: p1)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                    tangent2End: p2,
                    radius: radius)
        path.addLine(to: p3)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
                    tangent2End: p4,
                    radius: radius)
        path.addLine(to: p5)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                    tangent2End: p6,
                    radius: radius)
        path.addLine(to: p7)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
                    tangent2End: p8,
                    radius: radius)
        path.closeSubpath()

        return path
    }
}

// View extension, to be used like modifier:
// SomeView().roundedCorners(radius: 20, corners: [.topLeft, .bottomRight])
extension View {
    func cornerRadius(radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(RoundedCornersShape(radius: radius, corners: corners))
    }
}

struct ScrollWheelModifier: ViewModifier {
    @State private var subs = Set<AnyCancellable>() // Cancel onDisappear

    var action: (CGFloat, CGFloat) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear { trackScrollWheel() }
    }
    
    func trackScrollWheel() {
        NSApp.publisher(for: \.currentEvent)
            .filter { event in event?.type == .scrollWheel }
            .throttle(for: .milliseconds(200),
                      scheduler: DispatchQueue.main,
                      latest: true)
            .sink {
                if let event = $0 {
                    action(event.deltaX, event.deltaY)
                }
          }
          .store(in: &subs)
    }
}

extension View {
    func onScrollWheelUp(action: @escaping (CGFloat, CGFloat) -> Void) -> some View {
        modifier(ScrollWheelModifier(action: action) )
    }
}

#Preview {
    RoundedCornersShape(radius: 10)
        .frame(width: 200, height: 200)
}
