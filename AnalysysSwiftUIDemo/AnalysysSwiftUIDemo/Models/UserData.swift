//
//  UserData.swift
//  AnalysysSwiftUIDemo
//
//  Created by xiao xu on 2020/7/30.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import SwiftUI
//import Combine

final class UserData: ObservableObject {
    
    @Published var showFaoritesOnly = true
    @Published var landmarks = landmarkData
    @Published var profile = Profile.default
    
}
