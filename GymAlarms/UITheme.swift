import SwiftUI

// MARK: - Global Palette
struct AppPalette {

    // Backgrounds
    static let backgroundPrimary = Color(red: 7/255, green: 20/255, blue: 22/255)
    static let backgroundSecondary = Color(red: 13/255, green: 34/255, blue: 38/255)
    // Sheet background (requested: #0F1F24)
    static let sheetBackground = Color(red: 15/255, green: 31/255, blue: 36/255)

    // Brand colors
    static let primaryGreen = Color(red: 189/255, green: 240/255, blue: 0/255)
    static let restBlue = Color(red: 10/255, green: 132/255, blue: 255/255)
    static let restTrack = Color(red: 23/255, green: 68/255, blue: 113/255)

    // Partner/Third-party brand accents
    static let googleBlue = Color(red: 66/255, green: 133/255, blue: 244/255) // #4285F4
    static let partnerGreen = Color(red: 48/255, green: 209/255, blue: 88/255) // #30D158

    // Neutrals
    static let white = Color.white
    static let black = Color.black
    static let textSecondary = Color(red: 151/255, green: 153/255, blue: 141/255)

    // Shared strokes/fills (centralized opacities)
    static let fieldBorder = Color.white.opacity(0.12)
    static let divider05 = Color.white.opacity(0.05)
    static let stroke08 = Color.white.opacity(0.08)
    static let stroke10 = Color.white.opacity(0.10)
    static let cardFill04 = Color.white.opacity(0.04)
    static let dimWhite55 = Color.white.opacity(0.55)
    static let dimWhite50 = Color.white.opacity(0.50)

    // Helpers
    static func googleBlue(opacity: Double) -> Color { googleBlue.opacity(opacity) }
    static func white(_ opacity: Double) -> Color { white.opacity(opacity) }
}

// MARK: - Shared UI Components
struct AppBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppPalette.white)
                .frame(width: 36, height: 36)
                .background(AppPalette.backgroundSecondary)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Atrás")
    }
}

struct PrimaryButton: View {
    let title: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .default, weight: .semibold))
                .foregroundStyle(AppPalette.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppPalette.primaryGreen)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct SocialButton: View {
    enum Provider { case apple, google }
    let provider: Provider
    let title: String
    var action: () -> Void = {}

    private var logoName: String {
        switch provider {
        case .apple: return "applelogo"
        case .google: return "googlelogo"
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(logoName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .opacity(1.0)
                Text(title)
                    .font(.system(.subheadline, design: .default, weight: .semibold))
                    .foregroundStyle(AppPalette.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .stroke(AppPalette.fieldBorder, lineWidth: 1)
                    .background(AppPalette.backgroundSecondary.opacity(0))
            )
        }
        .buttonStyle(.plain)
    }
}

struct DividerLabel: View {
    let text: String
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Rectangle().fill(AppPalette.fieldBorder).frame(height: 1)
            Text(text)
                .font(.system(.footnote, design: .default))
                .foregroundStyle(AppPalette.textSecondary)
            Rectangle().fill(AppPalette.fieldBorder).frame(height: 1)
        }
    }
}

struct LabeledTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(.caption, design: .default, weight: .semibold))
                .foregroundStyle(AppPalette.textSecondary)
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(AppPalette.textSecondary.opacity(0.5)))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .font(.system(.body, design: .default))
                .padding(.vertical, 14)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppPalette.fieldBorder, lineWidth: 1)
                        .background(AppPalette.backgroundSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                )
                .foregroundStyle(AppPalette.white)
        }
    }
}

struct LabeledSecureField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    @State private var isSecure: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(.caption, design: .default, weight: .semibold))
                .foregroundStyle(AppPalette.textSecondary)

            HStack(spacing: 8) {
                Group {
                    if isSecure {
                        SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(AppPalette.textSecondary.opacity(0.5)))
                    } else {
                        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(AppPalette.textSecondary.opacity(0.5)))
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.system(.body, design: .default))
                .foregroundStyle(AppPalette.white)

                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundStyle(AppPalette.textSecondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppPalette.fieldBorder, lineWidth: 1)
                    .background(AppPalette.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            )
        }
    }
}
