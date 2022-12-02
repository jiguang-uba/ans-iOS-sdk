//
//  LandmarkList.swift
//  AnalysysSwiftUIDemo
//
//  Created by xiao xu on 2020/7/29.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import SwiftUI

struct LandmarkList: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                
                Toggle(isOn: $userData.showFaoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(userData.landmarks) {
                    landmark in
                    if self.userData.showFaoritesOnly || landmark.isFavorite {
                        NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                            LandmarkRow(landmark: landmark)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Landmarks"))
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        
        LandmarkList()
        .environmentObject(UserData())
        .previewDevice(PreviewDevice(rawValue: "iPhone X"))
        
    }
}
