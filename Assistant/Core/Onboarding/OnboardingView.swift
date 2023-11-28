//
//  OnboardingView.swift
//  VirtualAssistant
//
//  Created by Gytis Ptašinskas on 04/11/2023.
//

import SwiftUI

struct OnboardingView: View {
    let centerWidth = UIScreen.main.bounds.width / 2
    let centerHeight = UIScreen.main.bounds.height / 2
    
    @State private var positions: [CGPoint] = []
    @State private var frameSize: CGSize = .zero
    @State private var currentPage = 0
    
    private let blurRadius = 10.0
    private let alphaTreshold = 0.2
    private let ballCount = 5
    
    let onboardingContent = [
        OnboardingTextContent(title: "Virtual", title2: " Assistant", description: "Get to know your Virtual Assistant."),
        OnboardingTextContent(title: "Talk", title2: " with it", description: "Don't want to chat? You can also just use your microphone"),
        OnboardingTextContent(title: "Chat", title2: " with it", description: "You can't chat with your virtual assistant and get information that you need"),
    ]
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect().receive(on: RunLoop.main)
    init() {
        self.positions = Array(repeating: .zero, count: ballCount)
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    
                    Spacer()
                    
                    Image("onboarding")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width)
                        .aspectRatio(0.75, contentMode: .fit)
                        
                        .mask {
                            Canvas { context, size in
                                let circles = (0..<positions.count).map { tag in
                                    context.resolveSymbol(id: tag)!
                                }
                                context.addFilter(.alphaThreshold(min: alphaTreshold))
                                context.addFilter(.blur(radius: blurRadius))
                                context.drawLayer { context2 in
                                    circles.forEach { circle in
                                        context2.draw(circle, at: .init(
                                            x: size.width/2,
                                            y: size.height/2))
                                    }
                                }
                            } symbols: {
                                ForEach(positions.indices, id: \.self) { id in
                                    Circle()
                                        .frame(width: id == 0 ? geometry.size.width - blurRadius / alphaTreshold : geometry.size.width / 2).tag(id).offset(
                                            x: id == 0 ? 0 : positions[id].x,
                                            y: id == 0 ? 0 : positions[id].y)
                                }
                            }
                        }
                    
                    Spacer()
                    
                    TabView(selection: $currentPage) {
                        ForEach(0..<onboardingContent.count, id: \.self) { index in
                            OnboardingTextView(content: onboardingContent[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 100)
                    
                    Spacer()
                    
                    HStack {
                        ForEach(0..<onboardingContent.count, id: \.self) { index in
                            Capsule()
                                .fill(currentPage == index ? Color(uiColor: .systemGreen) : .gray)
                                .frame(width: currentPage == index ? 20 : 10, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            SignInView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Image(systemName: "chevron.forward")
                                .font(.title)
                                .foregroundStyle(.black)
                            
                        }
                        .padding()
                        .background(Color(uiColor: .systemGreen))
                        .clipShape(Circle())
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                }
                .onReceive(timer, perform: { _ in
                    withAnimation(.easeInOut(duration: 7)) {
                        positions = positions.map({ _ in
                            randomPosition(in: frameSize, ballSize: .init(width: geometry.size.width / 2, height: geometry.size.width / 2))
                        })
                    }
                })
                .onAppear {
                    frameSize = .init(width: geometry.size.width, height: geometry.size.width / 0.75)
                    self.positions = Array(repeating: .zero, count: ballCount)
                }
            }
        }
    }
}

func randomPosition(in bounds: CGSize, ballSize: CGSize) -> CGPoint {
    let xRange = ballSize.width / 2 ... bounds.width - ballSize.width / 2
    let yRange = ballSize.height / 2 ... bounds.height - ballSize.height / 2
    
    let randomX = CGFloat.random(in: xRange)
    let randomY = CGFloat.random(in: yRange)
    
    let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    
    let offsetX = randomX - center.x
    let offsetY = randomY - center.y
    
    return CGPoint(x: offsetX, y: offsetY)
}

struct OnboardingTextView: View {
    let content: OnboardingTextContent
    
    var body: some View {
        VStack(spacing: 12) {
            (Text(content.title) + Text(content.title2).bold().foregroundStyle(Color(uiColor: .systemGreen))
             
            )
            .font(.title)
            Text(content.description)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
        }
        .padding() // Add padding if needed
    }
}

struct OnboardingTextContent {
    let title: String
    let title2: String
    let description: String
}

#Preview {
    OnboardingView()
}
