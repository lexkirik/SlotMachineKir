//
//  ContentView.swift
//  SlotMachineKir
//
//  Created by Test on 5.10.23.
//

import SwiftUI

struct ContentView: View {
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var isActivateBet10: Bool = true
    @State private var isActivateBet20: Bool = false
    @State private var showingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }

    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            playerWins()
            if coins > highScore {
                newHighScore()
            } else {
                playSound(sound: "win", type: "mp3")
            }
        } else {
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
   
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        isActivateBet20 = true
        isActivateBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betAmount = 10
        isActivateBet10 = true
        isActivateBet20 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func isGameOver() {
        if coins <= 0 {
            showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    var body: some View {
        ZStack {
            //background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            
            //interface
            VStack (alignment: .center, spacing: 5) {
                //header
                LogoView()
                Spacer()
                
                //score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                //slot machine
                VStack(alignment: .center, spacing: 0) {
                    //reel 1
                    ZStack {
                        RealView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .onAppear(perform: {
                                withAnimation(.easeOut(duration: Double.random(in: 0.5...0.7))) {
                                    animatingSymbol.toggle()
                                    playSound(sound: "riseup", type: "mp3")
                                }
                            })
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        //reel 2
                        ZStack {
                            RealView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .onAppear(perform: {
                                    withAnimation(.easeOut(duration: Double.random(in: 0.7...0.9))) {
                                        animatingSymbol.toggle()
                                    }
                                })
                        }
                        Spacer()
                        //reel 3
                        ZStack {
                            RealView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .onAppear(perform: {
                                    withAnimation(.easeOut(duration: Double.random(in: 0.9...1.1))) {
                                        animatingSymbol.toggle()
                                    }
                                })
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    //spin button
                    Button(action: {
                        withAnimation {
                            animatingSymbol = false
                        }
                        spinReels()
                        withAnimation {
                            animatingSymbol = true
                        }
                        checkWinning()
                        isGameOver()
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                    
                }
                .layoutPriority(2)
                
                //footer

                Spacer()
                
                HStack {
                    //bet 20
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            activateBet20()
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundStyle(isActivateBet20 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActivateBet20 ? 0 : 20)
                            .opacity(isActivateBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    Spacer()
                    //bet 10
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActivateBet10 ? 0 : -20)
                            .opacity(isActivateBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            activateBet10()
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundStyle(isActivateBet10 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                    }
                }
            }
            //buttons
            .overlay(
                Button(action: {
                    resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                Button(action: {
                    showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            //popup
            if $showingModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .ignoresSafeArea(.all)
                    
                    VStack(alignment: .center) {
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundStyle(Color.white)
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            Text("Bad luck! You lost all of the coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                showingModal = false
                                animatingModal = false
                                activateBet10()
                                coins = 100
                            }, label: {
                                Text("NEW GAME")
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .tint(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                    Capsule()
                                        .strokeBorder(lineWidth: 1.75)
                                        .foregroundStyle(Color("ColorPink"))
                                    )
                            })
                        }
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .onAppear {
                        withAnimation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0)) {
                            animatingModal = true
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingInfoView, content: {
            InfoView()
        })
    }
}

#Preview {
    ContentView()
}
