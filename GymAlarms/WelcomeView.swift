import SwiftUI

// MARK: - WelcomeView
struct WelcomeView: View {
    // Color palette
    private let backgroundPrimary = AppPalette.backgroundPrimary
    private let backgroundSecondary = AppPalette.backgroundSecondary
    private let primaryGreen = AppPalette.primaryGreen
    private let white = AppPalette.white
    private let secondaryWhite = Color.white.opacity(0.7)
    private let secondaryGray = AppPalette.textSecondary

    // Layout metrics
    @ScaledMetric(relativeTo: .largeTitle) private var imageMaxWidth: CGFloat = 360
    @ScaledMetric private var verticalButtonPadding: CGFloat = 16

    private enum Layout {
        static let topSpacerMin: CGFloat = 24
        static let stackSpacing: CGFloat = 24
        static let titleSpacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 24
        static let subtitleHorizontalPadding: CGFloat = 32
        static let bottomPadding: CGFloat = 24
        static let secondaryButtonStrokeWidth: CGFloat = 1
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundPrimary.ignoresSafeArea()

                VStack(spacing: Layout.stackSpacing) {
                    Spacer(minLength: Layout.topSpacerMin)

                    Image("welcomeClockGlow")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: imageMaxWidth)
                        .accessibilityHidden(true)
                        .padding(.top, Layout.topSpacerMin)

                    VStack(spacing: Layout.titleSpacing) {
                        Text("¿Listo para entrenar")
                            .font(.system(.largeTitle, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(white)

                        Text("sin perder tu flow?")
                            .font(.system(.largeTitle, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(primaryGreen)
                    }
                    .padding(.horizontal, Layout.horizontalPadding)

                    Text("Tu temporizador de entrenamiento inteligente")
                        .font(.system(.subheadline, design: .default))
                        .foregroundStyle(secondaryGray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Layout.subtitleHorizontalPadding)

                    Spacer()

                    VStack(spacing: Layout.titleSpacing) {
                        NavigationLink(destination: RegisterView()) {
                            Text("Crear Cuenta")
                                .font(.system(.headline, design: .default, weight: .semibold))
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, verticalButtonPadding)
                                .background(primaryGreen)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: LoginView()) {
                            Text("Ya Tengo Cuenta")
                                .font(.system(.headline, design: .default, weight: .regular))
                                .foregroundStyle(white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, verticalButtonPadding)
                                .background(
                                    Capsule()
                                        .stroke(white.opacity(0.2), lineWidth: Layout.secondaryButtonStrokeWidth)
                                        .background(backgroundSecondary.opacity(0))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.bottom, Layout.bottomPadding)
                }
            }
        }
    }
}

#Preview("WelcomeView") {
    WelcomeView()
}
