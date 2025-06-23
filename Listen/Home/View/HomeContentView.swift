//
//  HomeContentView.swift
//  Listen
//
//  Created by Hitesh Madaan on 23/06/25.
//

import SwiftUI

struct HomeContentView: View {
    @Namespace private var animationNamespace
    @State private var selectedBannerIndex: Int? = nil
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Listen")
                    Spacer()
                    Image(systemName: "person.circle")
                }
                .padding(.top, 65)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                ScrollView(showsIndicators: false){
                    ForEach(0..<4, id: \.self) { index in
                        NoteBannerView(index: index)
                            .matchedGeometryEffect(id: index, in: animationNamespace)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    selectedBannerIndex = index
                                    isExpanded = true
                                }
                            }
                            .opacity(selectedBannerIndex == index && isExpanded ? 0 : 1)
                    }
                }
            }
            .blur(radius: isExpanded ? 10 : 0)
            
            // Full screen overlay
            if let index = selectedBannerIndex, isExpanded {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpanded = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            selectedBannerIndex = nil
                        }
                    }

                NoteDetailView(index: index)
                    .matchedGeometryEffect(id: index, in: animationNamespace)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpanded = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            selectedBannerIndex = nil
                        }
                    }
                    .zIndex(1)
            }
        }
    }
}

struct NoteBannerView: View {
    var index: Int

    var body: some View {
        VStack {
            Text("Note Banner \(index + 1)")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color.blue)
        .cornerRadius(24)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

struct NoteDetailView: View {
    var index: Int

    var body: some View {
        VStack {
            Spacer()
            Text("Full Detail for Note \(index + 1)")
                .font(.largeTitle)
                .foregroundColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 500)
        .background(Color.blue)
        .cornerRadius(24)
        .padding(16)
    }
}

#Preview {
    HomeContentView()
        .ignoresSafeArea()
}
