import SwiftUI

// MARK: - Shared Palette
struct AuthPalette {
    static let backgroundPrimary = Color(hex: "#071416")
    static let backgroundSecondary = Color(hex: "#0D2226")
    static let primaryGreen = Color(hex: "#BDF000")
    static let white = Color.white
    static let textSecondary = Color(hex: "#97998D")
    static let fieldBorder = Color.white.opacity(0.12)
}

// MARK: - Hex Color Helper
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

// MARK: - Auth Back Button
struct AuthBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AuthPalette.white)
                .frame(width: 36, height: 36)
                .background(AuthPalette.backgroundSecondary)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Atrás")
    }
}

// MARK: - Primary Auth Button
struct PrimaryAuthButton: View {
    let title: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AuthPalette.primaryGreen)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Social Auth Button
struct SocialAuthButton: View {
    enum Provider { case apple, google }
    let provider: Provider
    let title: String
    var action: () -> Void = {}

    private var logoName: String {
        switch provider {
        case .apple: return "appleLogo"
        case .google: return "googleLogo"
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
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(AuthPalette.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .stroke(AuthPalette.fieldBorder, lineWidth: 1)
                    .background(AuthPalette.backgroundSecondary.opacity(0))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Auth Divider
struct AuthDivider: View {
    let text: String
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Rectangle().fill(AuthPalette.fieldBorder).frame(height: 1)
            Text(text)
                .font(.system(.footnote, design: .rounded))
                .foregroundStyle(AuthPalette.textSecondary)
            Rectangle().fill(AuthPalette.fieldBorder).frame(height: 1)
        }
    }
}

// MARK: - Auth Text Field
struct AuthTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundStyle(AuthPalette.textSecondary)
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .font(.system(.body, design: .rounded))
                .padding(.vertical, 14)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AuthPalette.fieldBorder, lineWidth: 1)
                        .background(AuthPalette.backgroundSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                )
                .foregroundStyle(AuthPalette.white)
        }
    }
}

// MARK: - Auth Secure Field (with optional eye icon toggle)
struct AuthSecureField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    @State private var isSecure: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundStyle(AuthPalette.textSecondary)

            HStack(spacing: 8) {
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(AuthPalette.white)

                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundStyle(AuthPalette.textSecondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AuthPalette.fieldBorder, lineWidth: 1)
                    .background(AuthPalette.backgroundSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            )
        }
    }
}

#Preview("Auth Components") {
    ScrollView {
        VStack(spacing: 16) {
            AuthBackButton()
            PrimaryAuthButton(title: "Continuar") {}
            SocialAuthButton(provider: .apple, title: "Continuar con Apple") {}
            SocialAuthButton(provider: .google, title: "Continuar con Google") {}
            AuthDivider(text: "o continuar con")
            AuthTextField(label: "CORREO ELECTRÓNICO", placeholder: "example@gmail.com", text: .constant(""))
            AuthSecureField(label: "CONTRASEÑA", placeholder: "••••••••", text: .constant(""))
        }
        .padding()
        .background(AuthPalette.backgroundPrimary)
    }
}
