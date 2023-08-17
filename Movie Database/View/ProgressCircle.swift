//
//  ProgressCircle.swift
//  Movie Database
//
//  Created by M_AMBIN06088 on 17/08/23.
//

import UIKit
import SwiftUI

struct ProgressView: View {
    @State var progressValue: Float = 0.0
    @State var value: String = ""
    
    var body: some View {
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ProgressCircle(progress: $progressValue, value: $value)
                    .frame(width: 150.0, height: 150.0)
                    .padding(40.0)
                Spacer()
            }
        }
    }
}

struct ProgressCircle: View {
    
    @Binding var progress: Float
    @Binding var value: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.blue)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(self.value)
                .font(.title)
                .bold()
        }
    }
}

#Preview {
    ProgressView()
}


extension UIViewController {
    /// component: View created by SwiftUI
    /// targetView: The UIView that will host the component
    func host(component: AnyView, into targetView: UIView) {
        let controller = UIHostingController(rootView: component)
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        targetView.addSubview(controller.view)
        controller.didMove(toParent: self)

        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: targetView.widthAnchor, multiplier: 1),
            controller.view.heightAnchor.constraint(equalTo: targetView.heightAnchor, multiplier: 1),
            controller.view.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: targetView.centerYAnchor)
        ])
    }
}
