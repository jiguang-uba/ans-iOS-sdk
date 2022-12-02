//
//  RotatedBadgeSymbol.swift
//  AnalysysSwiftUIDemo
//
//  Created by xiao xu on 2020/8/4.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import SwiftUI

struct RotatedBadgeSymbol: View {
    
    let angle: Angle
    
    var body: some View {
        
        BadgeSymbol()
        .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct RotatedBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        RotatedBadgeSymbol(angle: .init(degrees: 5))
    }
}
