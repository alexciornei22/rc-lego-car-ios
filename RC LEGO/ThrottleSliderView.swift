//
//  SwiftUIView.swift
//  RC LEGO
//
//  Created by Alex on 20.05.2024.
//

import SwiftUI

struct ThrottleSliderView: View {
    @Binding var sliderHeight: CGFloat
    @State var lastDragValue: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Rectangle()
                
                Rectangle()
                    .fill(.green)
                    .frame(height: sliderHeight)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .gesture(DragGesture()
                .onChanged { value in
                    var newHeight = -value.translation.height + lastDragValue
                    
                    if newHeight < 0 { newHeight = 0 }
                    if newHeight > proxy.size.height {
                        newHeight = proxy.size.height
                    }
                    sliderHeight = newHeight
                }
                .onEnded { _ in
                    lastDragValue = sliderHeight
                }
            )
        }
    }
}

#Preview {
    GeometryReader { proxy in
        ThrottleSliderView(sliderHeight: .constant(proxy.size.height / 3))
    }
}
