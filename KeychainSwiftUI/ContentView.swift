//
//  ContentView.swift
//  KeychainSwiftUI
//
//  Created by Vasichko Anna on 04.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var password = ""
    @State private var account = ""
    @State private var status = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("My password is", text: $password)
                    .textFieldStyle(.roundedBorder)
                TextField("My accont is", text: $account)
                    .textFieldStyle(.roundedBorder)
                    
                Button("Save data") {
                    do {
                        status = try KeychainManager.save(
                            password: password.data(using: .utf8) ?? Data(),
                            andAccount: account)
                        
                    } catch {
                        print(error)
                    }
                }
                
                Button("See current password for account") {
                    do {
                        let data = try KeychainManager.getPassword(for: account)
                        status = String(
                            decoding: data ?? Data(),
                            as: UTF8.self
                        )
                    } catch {
                        print(error)
                    }
                }
                
                Text(status)
                    .font(.largeTitle)
                    .foregroundColor(.red)
      
                Spacer()
            }
            .padding()
            .navigationTitle("Save your password")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
