
import SwiftUI

enum Gender: String, CaseIterable, Identifiable {
    case male, female
    //nonBinary
    var id: Self { self }
    var label: String { rawValue.capitalized }
}

enum ColdProfile: String, CaseIterable, Identifiable {
    case runCold   = "I run cold 🥶"
    case neutral   = "Neutral 🙂"
    case runHot    = "I run hot 🥵"
    var id: Self { self }
}

enum BroadStyle: String, CaseIterable, Identifiable {
    case casual, elegant, sporty
         
         //streetwear
    var id: Self { self }
    var label: String { rawValue.capitalized }
}
