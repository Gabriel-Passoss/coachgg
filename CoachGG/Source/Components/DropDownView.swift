//
//  DropDownView.swift
//  CoachGG
//
//  Created by Gabriel on 05/08/25.
//

import SwiftUI

enum DropdownAnchor {
    case top
    case bottom
}


struct DropDownView: View {
    var hint: String
    var options: [String]
    var anchor: DropdownAnchor = .bottom
    var maxWidth: CGFloat = 175
    var cornerRadius: CGFloat = 8
    @Binding var selection: String?
    
    @State private var showOptions = false
    
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State private var zIndex = 1000.0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                if showOptions && anchor == .top {
                    optionsView()
                }
                
                HStack(spacing: 0) {
                    Text(selection ?? hint)
                        .font(.system(size: 14))
                        .foregroundStyle(selection == nil ? ColorTheme.slate400 : ColorTheme.gray100)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.down")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .rotationEffect(.init(degrees: showOptions ? -180 : 0))
                }
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .background(ColorTheme.slate800)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        index += 1
                        zIndex = index
                        showOptions.toggle()
                    }
                }
                .zIndex(zIndex)
                
                if showOptions && anchor == .bottom {
                    optionsView()
                }
            }
            .clipped()
            .background(ColorTheme.slate800)
            .cornerRadius(cornerRadius)
            .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
        }
        .frame(maxWidth: maxWidth, maxHeight: 42)
    }
    
    @ViewBuilder
    func optionsView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    HStack(spacing: 0) {
                        Text(option)
                            .lineLimit(1)
                        
                        Spacer(minLength: 0)
                        
                        Image(systemName: "checkmark")
                            .opacity(selection == option ? 1 : 0)
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(selection == option ? ColorTheme.gray100 : ColorTheme.slate400)
                    .animation(.none, value: selection)
                    .frame(height: 40)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selection = option
                            showOptions = false
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .frame(height: 200)
        .transition(.move(edge: anchor == .top ? .bottom : .top))
    }
}

#Preview {
    @Previewable @State var selection: String? = nil
    
    VStack {
        Spacer()
        
        DropDownView(
            hint: "Região",
            options: Region.allCases.map { $0.stringValue },
            anchor: .top,
            selection: $selection
        )
        
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ColorTheme.slate900)
    
}
