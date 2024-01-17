//
//  InfoView.swift
//  SlotMachineKir
//
//  Created by Test on 7.10.23.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section {
                    FormRowView(firstItem: "Application", secondItem: "Slot machine")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Aliaksei")
                    FormRowView(firstItem: "Website", secondItem: "@pterokir")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                } header: {
                    Text("About the application")
                }
            }
            .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                audioPlayer?.stop()
                presentationMode.callAsFunction()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            } )
            .padding(.top, 30)
            .padding(.trailing, 20)
            .tint(Color.secondary)
        }
        .onAppear(perform: {
            playSound(sound: "background-music", type: "mp3")
        })
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    
    var body: some View {
        HStack {
            Text(firstItem)
                .foregroundStyle(Color.gray)
            Spacer()
            Text(secondItem)
        }
    }
}

#Preview {
    InfoView()
}

