//
//  HikeBadge.swift
//  AnalysysSwiftUIDemo
//
//  Created by xiao xu on 2020/8/5.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import SwiftUI

struct HikeBadge: View {
    var name: String
    var body: some View {
        VStack(alignment: .center) {
            Badge()
                .frame(width: 100, height: 100)
                .scaleEffect(2.0 / 3.0)
            Text(name)
                .font(.caption)
                .accessibility(label: Text("Badge for \(name)."))
        }
    }
}

struct HikeBadge_Previews: PreviewProvider {
    static var previews: some View {
        HikeBadge(name: "Preview Testing")
    }
}
