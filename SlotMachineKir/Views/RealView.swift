//
//  RealView.swift
//  SlotMachineKir
//
//  Created by Test on 6.10.23.
//

import SwiftUI

struct RealView: View {
    var body: some View {
        Image("gfx-reel")
            .resizable()
            .modifier(ImageModifier())
    }
}

#Preview {
    RealView()
}
