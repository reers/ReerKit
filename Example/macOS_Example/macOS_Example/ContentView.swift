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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("SGVsbG8sIHdvcmxkIQ==".re.base64Decoded!)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
