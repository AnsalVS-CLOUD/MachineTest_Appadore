//
//  Style.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 24/06/25.
//
import SwiftUI

struct AppColors {
    static let background = Color.orange.opacity(0.8)
    static let primaryText = Color.primary
    static let accent = Color.orange
    static let buttonText = Color.white
    static let buttonBackground = Color.blue
    static let secondaryBackground = Color(.systemGray6)
    static let overlay = Color.black.opacity(0.5)
    static let backgroundOption = Color(.systemBackground) 
}


struct AppFonts {
    static func titleFont() -> Font {
        Font.system(size: 32, weight: .bold)
    }
    
    static func headingFont() -> Font {
        Font.system(size: 24, weight: .semibold)
    }
    
    static func bodyFont() -> Font {
        Font.system(size: 18, weight: .regular)
    }
    
    static func buttonFont() -> Font {
        Font.system(size: 20, weight: .medium)
    }
    
    static func captionFont() -> Font {
        Font.system(size: 14, weight: .light)
    }
    
    static func countdownFont() -> Font {
        Font.system(size: 36, weight: .black, design: .monospaced)
    }
}
