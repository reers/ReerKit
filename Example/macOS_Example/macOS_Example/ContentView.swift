//
//  ContentView.swift
//  macOS_Example
//
//  Created by phoenix on 2024/1/11.
//

import SwiftUI
import ReerKit

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.re("FD7979").re.darken(colorSpace: .displayP3)
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.white)
                Text("SGVsbG8sIHdvcmxkIQ==".re.base64Decoded!)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
