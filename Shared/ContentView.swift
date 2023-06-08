
//
//  ContentView.swift
//  Walkation
//
//  Created by MATT on 20/5/2023.
//

import SwiftUI
import AVFAudio



// 定義一個 UIViewControllerRepresentable 的結構
//繪製圍欄，圖標，自定義地圖
struct MapViewControllerWrapper: UIViewControllerRepresentable {
    // 定義一個 updateUIViewController 方法
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        // 可以在這裡更新 UIViewController 的屬性或方法
    }
    
    // 定義一個 makeUIViewController 方法
    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController()
    }
}


// 定義一個 UIViewControllerRepresentable 的結構
//繪製圍欄，圖標，自定義地圖
struct NavigationViewControllerWrapper: UIViewControllerRepresentable {
    // 定義一個 updateUIViewController 方法
    func updateUIViewController(_ uiViewController: NavigationViewController, context: Context) {
        // 可以在這裡更新 UIViewController 的屬性或方法
    }
    
    // 定義一個 makeUIViewController 方法
    func makeUIViewController(context: Context) -> NavigationViewController {
        return NavigationViewController()
    }
}



// 在 ContentView 中使用 MapViewControllerWrapper 來顯示 UIViewController
struct ContentView: View {
    var body: some View {
        NavigationViewControllerWrapper()
            .edgesIgnoringSafeArea(.all)
            
    }
    
}
