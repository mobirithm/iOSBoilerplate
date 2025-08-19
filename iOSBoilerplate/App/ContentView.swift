//
//  ContentView.swift
//  iOSBoilerplate
//
//  Created by Mobirithm Dev Team
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "swift")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("iOS Boilerplate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("SwiftUI Template")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Version:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build:")
                            .fontWeight(.medium)
                        Spacer()
                        Text(buildNumber)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
                
                Text("Ready for rapid consumer app development")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .navigationTitle("Home")
        }
    }
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}

#Preview {
    ContentView()
}