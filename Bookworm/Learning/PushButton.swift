//
//  PushButton.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

import SwiftUI

struct PushButtonLocalState: View {
    
    let title: String
    @State var isOn: Bool

    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct PushButtonBinding: View {
    
    let title: String
    @Binding var isOn: Bool

    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]

    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct PushButton: View {
    
    @State private var rememeberMe1 = false
    
    @State private var rememeberMe2 = false
    
    var body: some View {
        VStack {
            HStack {
                // the following custon View only get a copy the local Boolean value at View's creation
                // Then the value of the custom View's local @State boolean isOn is known only internally
                // it's a "one-way" flow of information: Parent View gives a value to the Child which doesn't share back any future changes
                PushButtonLocalState(title: "Remember me ?", isOn: rememeberMe1)
                Spacer()
                // hence when the PushButton 'isOn' local @State propeerty changes, it is not reflected in the parent View's local @State property 'rememberMe1':
                Text( rememeberMe1 ? "On" : "Off")
            }
            .padding()
            
            // impossible in this case to change the internal @State of the Push Button once created and even if 'rememberMe1' is changed along the time
            // for this Push Button, only the Boolean value of 'rememberMe1' was copied and is not connected anymore to the current state of this @State var:
            Button("Change programmaticaly the 1st PushButton") {
                self.rememeberMe1.toggle()
            }
            .buttonStyle(.borderedProminent)
            
            HStack {
                // the following custom View takes a @Binding var for its 'isOn' property, meaning that the parent View's @State property 'remember2' is shared between both Child and Parent Views at any time
                // it's 'two-way' flow of information: the Boolean value of 'rememberMe2' is not passed to the view but the Binding itself
                // it also means that PushButton 'isOn' state can be programmatically changed from outside the component (child view)
                PushButtonBinding(title: "Remember me ?", isOn: $rememeberMe2)
                Spacer()
                Text( rememeberMe2 ? "On" : "Off")
                
            }
            .padding()
            
            Button("Change programmaticaly the 2nd PushButton") {
                self.rememeberMe2.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct PushButton_Previews: PreviewProvider {
    static var previews: some View {
        PushButton()
    }
}
