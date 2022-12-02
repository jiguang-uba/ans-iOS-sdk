//
//  CategoryHome.swift
//  AnalysysSwiftUIDemo
//
//  Created by xiao xu on 2020/8/4.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import SwiftUI

struct CategoryHome: View {
    
    var category: [String : [Landmark]] {
        Dictionary(
            grouping: landmarkData,
            by: {
                (element) in
                return element.category.rawValue
            }
        )
    }
    
    var featured: [Landmark] {
        landmarkData.filter { (landmark) -> Bool in
            return landmark.isFeatured
        }
    }
    
    @State var showingProfile = false
    @EnvironmentObject var userData: UserData
    
    var profileButton: some View {
        Button(action: {
            self.showingProfile.toggle()
        }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
            .accessibility(label: Text("User Profile"))
            .padding()
        }
    }
    
    
    var body: some View {
        NavigationView {
            List {
                FeaturedLandmarks(landmarks: self.featured)
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                
                ForEach(category.keys.sorted(), id: \.self) {
                    key in
                    CategoryRow(categoryName: key, items: self.category[key]!)
                }
                .listRowInsets(EdgeInsets())
                
                NavigationLink(destination: LandmarkList()) {
                    Text("See All")
                }
            }
            .navigationBarTitle(Text("Featured"))
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(self.userData)
            }
        }
        
    }
}

struct FeaturedLandmarks: View {
    var landmarks: [Landmark]
    var body: some View {
        landmarks[0].image.resizable()
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
    }
}
