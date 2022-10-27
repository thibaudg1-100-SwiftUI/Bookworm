//
//  TextEditorAppStorage.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

import SwiftUI

// A very simple Notes app, suing @AppStorage for data persistance
struct TextEditorAppStorage: View {
    
    // @AppStorage is not designed to store secure information, so never use it for anything private.
    @AppStorage("notes") private var notes = ""
    
    var body: some View {
        
        NavigationView {
            // TextEditor is useful for multi-line text input:
            TextEditor(text: $notes)
                .navigationTitle("Notes")
                .padding()
        }
    }
}

struct TextEditorAppStorage_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorAppStorage()
    }
}
