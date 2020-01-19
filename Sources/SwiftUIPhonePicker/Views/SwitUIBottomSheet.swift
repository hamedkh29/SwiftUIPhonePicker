//
//  SwiftUIBottomSheet.swift
//
//  Created by Majid Jabrayilov
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI
fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}
struct SwiftUIBottomSheet<Content: View>: View {
    @Binding var isOpen: Bool
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    @GestureState private var translation: CGFloat = 0
    private let onClose: () -> Void
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight
        ).onTapGesture {
            withAnimation(.spring()){
                   self.isOpen.toggle()
                   self.onClose()
                  }
        }
    }
    init(isOpen: Binding<Bool>, maxHeight: CGFloat,
         onClose: @escaping  () -> Void = {},
        @ViewBuilder content: () -> Content) {
    self.minHeight = maxHeight * Constants.minHeightRatio
    self.maxHeight = maxHeight
    self.content = content()
    self._isOpen = isOpen
        self.onClose = onClose
    }
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
struct SwiftUIBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIBottomSheet(isOpen: .constant(false), maxHeight: 600) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}
