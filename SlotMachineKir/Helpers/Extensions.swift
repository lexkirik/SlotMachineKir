//
//  Extensions.swift
//  SlotMachineKir
//
//  Created by Test on 5.10.23.
//

import SwiftUI

extension Text {
    func scoreLabelStyle() -> Text {
        self
            .foregroundStyle(Color.white)
            .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    
    func scoreNumberStyle() -> Text {
        self
            .foregroundStyle(Color.white)
            .font(.system(.title, design: .rounded))
            .fontWeight(.heavy)
    }
}
