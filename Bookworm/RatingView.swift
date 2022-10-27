//
//  RatingView.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

import SwiftUI

struct RatingView: View {
    
    @Binding var rating: Int // the rating for this view
    
    var maxRating = 5 // max score for this rating view
    var label = "" // the label in front of the stars (or other image)
    var offImage: Image? // default: nil, the image to show for when rating is under max score
    var onImage = Image(systemName: "star.fill") // the default image when rating is greater than star's position
    var offColor = Color.gray // the color to show for star's position higher than the rating
    var onColor = Color.yellow // the color to show for star's position lower than the rating
    
    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)
            }
            
            ForEach(1..<maxRating+1) { position in
                image(for: position)
                    .foregroundColor(position > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = position
                    }
                    // for project 15 : accessibility
//                    .accessibilityLabel("\(position == 1 ? "1 star" : "\(position) stars")")
//                    .accessibilityRemoveTraits(.isImage)
//                    .accessibilityAddTraits(position > rating ? .isButton : [.isButton, .isSelected])
            }
        }
        // alternatively a better approach to accessibility:
        .accessibilityElement()
        .accessibilityLabel(label)
        .accessibilityValue(rating == 1 ? "1 star" : "\(rating) stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if rating < maxRating { rating += 1 }
            case .decrement:
                if rating > 1 { rating -= 1 }
            default:
                break
            }
        }
    }
    
    func image(for position: Int) -> Image {
        if position > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(3))
    }
}
