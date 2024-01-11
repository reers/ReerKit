//
//  ContentView.swift
//  watchOS_Example Watch App
//
//  Created by phoenix on 2024/1/10.
//

import SwiftUI
import ReerKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("aGVsbG8gd29ybGQ=".re.base64Decoded!)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
