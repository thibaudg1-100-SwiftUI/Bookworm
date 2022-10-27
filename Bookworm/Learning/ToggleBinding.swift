//
//  ToggleBinding.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

import SwiftUI

struct ToggleBinding: View {
    
    // Mutable varaible that is local to this view and when changing will reinvoke body property of the Struct
    @State private var rememberMe = false
    
    var body: some View {
        // Toggle(): built-in SwiftUI component (View) that is not changing a local-to-the-component @State var, but internally a @Binding mutable value that is coming from an external View (here our main View: ToggleBinding)
        Toggle("Remember me?", isOn: $rememberMe)
            .padding()
        
    }
}

struct ToggleBinding_Previews: PreviewProvider {
    static var previews: some View {
        ToggleBinding()
    }
}
