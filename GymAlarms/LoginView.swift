import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            AuthPalette.backgroundPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Top bar with back button
                    HStack {
                        AuthBackButton()
                        Spacer()
                    }
                    .padding(.top, 8)

                    // Title & Subtitle
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Iniciar Sesión")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .foregroundStyle(AuthPalette.white)
                        Text("¡Bienvenido de vuelta! 👋")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(AuthPalette.textSecondary)
                    }

                    // Form
                    VStack(spacing: 16) {
                        AuthTextField(label: "CORREO ELECTRÓNICO", placeholder: "example@gmail.com", text: $email)
                        AuthSecureField(label: "CONTRASEÑA", placeholder: "••••••••", text: $password)

                        // Forgot password link
                        HStack {
                            Spacer()
                            Button(action: {}) {
                                Text("¿Olvidaste tu contraseña?")
                                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Color.blue)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Primary CTA
                    PrimaryAuthButton(title: "Iniciar Sesión") {}

                    // Secondary action demo
                    Button(action: {}) {
                        Text("→ Continuar como invitado (demo)")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(AuthPalette.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)

                    // Divider
                    AuthDivider(text: "o continuar con")

                    // Social buttons
                    VStack(spacing: 12) {
                        SocialAuthButton(provider: .apple, title: "Continuar con Apple") {}
                        SocialAuthButton(provider: .google, title: "Continuar con Google") {}
                    }

                    // Bottom link to register
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?")
                            .foregroundStyle(AuthPalette.textSecondary)
                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Regístrate")
                                .foregroundStyle(AuthPalette.primaryGreen)
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.plain)
                    }
                    .font(.system(.footnote, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("LoginView") {
    NavigationStack {
        LoginView()
    }
}
