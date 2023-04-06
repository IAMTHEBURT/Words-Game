//
//  WordsApp.swift
//  Words
//
//  Created by Иван Львов on 08.12.2022.
//

import SwiftUI

@main
struct WordsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
                }
        }
    }
}
