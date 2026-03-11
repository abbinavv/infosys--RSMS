//
//  AppTypography.swift
//  infosys2
//
//  Elegant typography system using Didot (serif display) and system sans-serif.
//

import SwiftUI

struct AppTypography {

    // MARK: - Display / Headlines (Serif — Didot)

    /// Large display title — 34pt Didot
    static let displayLarge = Font.custom("Didot", size: 34).weight(.bold)

    /// Medium display — 28pt Didot
    static let displayMedium = Font.custom("Didot", size: 28).weight(.bold)

    /// Small display — 24pt Didot
    static let displaySmall = Font.custom("Didot", size: 24).weight(.bold)

    // MARK: - Headings (Serif — Didot)

    /// Heading 1 — 22pt
    static let heading1 = Font.custom("Didot", size: 22).weight(.semibold)

    /// Heading 2 — 20pt
    static let heading2 = Font.custom("Didot", size: 20).weight(.semibold)

    /// Heading 3 — 18pt
    static let heading3 = Font.custom("Didot", size: 18).weight(.medium)

    // MARK: - Body (System San Francisco)

    /// Body large — 17pt (iOS default body)
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)

    /// Body medium — 15pt
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)

    /// Body small — 13pt
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

    // MARK: - Labels & Captions

    /// Label — 15pt medium
    static let label = Font.system(size: 15, weight: .medium, design: .default)

    /// Caption — 12pt
    static let caption = Font.system(size: 12, weight: .regular, design: .default)

    /// Overline / Eyebrow — 11pt uppercase tracking
    static let overline = Font.system(size: 11, weight: .semibold, design: .default)

    // MARK: - Buttons

    /// Primary button — 16pt semibold
    static let buttonPrimary = Font.system(size: 16, weight: .semibold, design: .default)

    /// Secondary button — 14pt medium
    static let buttonSecondary = Font.system(size: 14, weight: .medium, design: .default)

    // MARK: - Navigation

    /// Tab bar label
    static let tabLabel = Font.system(size: 10, weight: .medium, design: .default)

    /// Navigation title
    static let navTitle = Font.custom("Didot", size: 18).weight(.semibold)

    // MARK: - Price

    /// Price display — 22pt semibold
    static let priceDisplay = Font.system(size: 22, weight: .semibold, design: .default)

    /// Price small — 16pt medium
    static let priceSmall = Font.system(size: 16, weight: .medium, design: .default)
}
