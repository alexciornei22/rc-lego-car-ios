//
//  SwiftUIView.swift
//  RC LEGO
//
//  Created by Alex on 20.05.2024.
//

import SwiftUI

struct ThrottleSliderView: View {
    @Binding var sliderPercentage: CGFloat
    @State var height: CGFloat = 0
    @State var lastDragValue: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let maxHeight = proxy.size.height
            
            ZStack(alignment: .bottom) {
                Rectangle()
                
                Rectangle()
                    .fill(.green)
                    .frame(height: height)
            }
            .frame(width: proxy.size.width, height: maxHeight)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .gesture(DragGesture(minimumDistance: 1)
                .onChanged { value in
                    var newHeight = -value.translation.height + lastDragValue
                    
                    if newHeight < 0 { newHeight = 0 }
                    if newHeight > proxy.size.height {
                        newHeight = proxy.size.height
                    }
                    
                    height = newHeight
                    sliderPercentage = (height / maxHeight) * 100
                }
                .onEnded { _ in
                    lastDragValue = height
                }
            )
        }
    }
}

#Preview {
    GeometryReader { proxy in
        ThrottleSliderView(sliderPercentage: .constant(proxy.size.height / 3))
    }
}
