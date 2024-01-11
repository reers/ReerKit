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
            Text("Hello, world!".re.md5String!)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
