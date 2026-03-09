import SwiftUI

// MARK: - WelcomeView
struct WelcomeView: View {
    // Color palette
    private let backgroundPrimary = AuthPalette.backgroundPrimary
    private let backgroundSecondary = AuthPalette.backgroundSecondary
    private let primaryGreen = AuthPalette.primaryGreen
    private let white = AuthPalette.white
    private let secondaryWhite = Color.white.opacity(0.7)
    private let secondaryGray = AuthPalette.textSecondary

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                backgroundPrimary
                    .ignoresSafeArea()

                // Content
                VStack(spacing: 24) {
                    Spacer(minLength: 24)

                    // Top image centered upper-middle
                    Image("welcomeClockGlow")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 360)
                        .accessibilityHidden(true)
                        .padding(.top, 24)

                    // Main text block
                    VStack(spacing: 8) {
                        // Title lines using system display style
                        Text("¿Listo para entrenar")
                            .font(.system(.largeTitle, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(white)

                        Text("sin perder tu flow?")
                            .font(.system(.largeTitle, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(primaryGreen)
                    }
                    .padding(.horizontal, 24)

                    // Subtitle
                    Text("Tu temporizador de entrenamiento inteligente")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(secondaryGray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Spacer()

                    // Buttons block
                    VStack(spacing: 12) {
                        // Primary button as NavigationLink
                        NavigationLink(destination: RegisterView()) {
                            Text("Crear Cuenta")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(primaryGreen)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)

                        // Secondary button as NavigationLink
                        NavigationLink(destination: LoginView()) {
                            Text("Ya Tengo Cuenta")
                                .font(.system(.headline, design: .rounded, weight: .regular))
                                .foregroundStyle(white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    Capsule()
                                        .stroke(white.opacity(0.2), lineWidth: 1)
                                        .background(backgroundSecondary.opacity(0))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

#Preview("WelcomeView") {
    NavigationStack {
        WelcomeView()
    }
}
