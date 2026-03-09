import SwiftUI

// MARK: - Global Palette
struct AppPalette {
    // Backgrounds
    static let backgroundPrimary = Color(hex: "#071416")
    static let backgroundSecondary = Color(hex: "#0D2226")

    // Brand colors
    static let primaryGreen = Color(hex: "#BDF000")
    static let restBlue = Color(hex: "#0A84FF")   // descanso (dinámico)
    static let restTrack = Color(hex: "#174471")  // aro de fondo (descanso)

    // Neutrals
    static let white = Color.white
    static let textSecondary = Color(hex: "#97998D")
    static let fieldBorder = Color.white.opacity(0.12)
}

// MARK: - Hex Color Helper (global único)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
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
                .foregroundStyle(Color.black)
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
