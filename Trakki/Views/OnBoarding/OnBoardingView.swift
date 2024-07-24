//
//  OnBoardingView.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 14/07/24.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var currentStep = 0
    @State private var showContentView = false
    
    let data: [OnBoarding] = [
        OnBoarding(image: "1", title: "Track Expenses", subTitle: "Manage your spending with ease."),
        OnBoarding(image: "2", title: "Track Income", subTitle: "Keep an eye on your earnings effortlessly."),
        OnBoarding(image: "3", title: "Financial Analysis", subTitle: "Gain insights with powerful analytics."),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentStep.animation()) {
                    ForEach(data.indices, id: \.self) { index in
                        VStack {
                            Image(data[index].image)
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: 450)
                            
                            Text(data[index].title)
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .multilineTextAlignment(.center)
                            
                            Text(data[index].subTitle)
                                .foregroundStyle(.gray)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .multilineTextAlignment(.center)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(data.indices, id: \.self) { index in
                            if index == currentStep {
                                Rectangle()
                                    .frame(width: 30, height: 10)
                                    .foregroundColor(Color("bgGreen"))
                                    .cornerRadius(5)
                            } else {
                                Circle()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(Color.gray.opacity(0.5))
                            }
                        }
                    }
                    .padding()
                    .scrollTargetLayout()                                             
                }
                .background(.clear, in: RoundedRectangle(cornerRadius: 30))
                .frame(width: 90)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: Binding($currentStep), anchor: .center)
                .allowsTightening(false)
                
                if currentStep == data.count - 1 {
                    Button {
                        showContentView = true
                    } label: {
                        Text("Continue")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.black.opacity(0.8))
                            .padding()
                    }
                    .navigationDestination(isPresented: $showContentView) {
                        SignInView()
                    }

                } else {
                    Button(action: {
                        withAnimation {
                            if currentStep < data.count - 1 {
                                currentStep += 1
                            }
                        }
                    }) {
                        Text("Continue")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.black.opacity(0.8))
                            .padding()
                    }
                }
            }
        }
    }
}
#Preview {
    OnBoardingView()
}
