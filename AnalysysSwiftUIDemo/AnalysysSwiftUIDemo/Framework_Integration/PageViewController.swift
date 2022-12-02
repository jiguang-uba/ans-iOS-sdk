//
//  PageViewController.swift
//  AnalysysSwiftUIDemo
//
//  Created by xiao xu on 2020/8/6.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import SwiftUI
import UIKit

struct PageViewController: UIViewControllerRepresentable {
    
    var controllers: [UIViewController]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true) { (bool) in
            //
        }
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var parent: PageViewController
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let index = parent.controllers.firstIndex(of: viewController) else { return nil }
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
            
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            guard let index = parent.controllers.firstIndex(of: viewController) else { return nil }
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
    }
}

struct PageViewController_Previews: PreviewProvider {
    static var previews: some View {
        Text("aaa")
    }
}
