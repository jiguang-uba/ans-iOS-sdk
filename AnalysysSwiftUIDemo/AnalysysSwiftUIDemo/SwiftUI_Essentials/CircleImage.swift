//
//  CircleImage.swift
//  AnalysysSwiftUIDemo
//
//  Created by xiao xu on 2020/7/29.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    var image: Image
    
    var body: some View {
        
        image
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            .shadow(radius: 10)
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("mountain"))
    }
}
