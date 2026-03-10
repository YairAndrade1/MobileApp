import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var goToGoogle: Bool = false
    @State private var goToApple: Bool = false
    @State private var goToHome: Bool = false

    var body: some View {
        ZStack {
            AppPalette.backgroundPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Top bar with back button
                    HStack {
                        AppBackButton()
                        Spacer()
                    }
                    .padding(.top, 8)

                    // Title & Subtitle
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Iniciar Sesión")
                            .font(.system(.largeTitle, design: .default, weight: .bold))
                            .foregroundStyle(AppPalette.white)
                        Text("¡Bienvenido de vuelta! 👋")
                            .font(.system(.subheadline, design: .default))
                            .foregroundStyle(AppPalette.textSecondary)
                    }

                    // Form
                    VStack(spacing: 16) {
                        LabeledTextField(label: "CORREO ELECTRÓNICO", placeholder: "example@gmail.com", text: $email)
                        LabeledSecureField(label: "CONTRASEÑA", placeholder: "••••••••", text: $password)

                        // Forgot password link
                        HStack {
                            Spacer()
                            NavigationLink {
                                ForgotPasswordView()
                            } label: {
                                Text("¿Olvidaste tu contraseña?")
                                    .font(.system(.footnote, design: .default, weight: .semibold))
                                    .foregroundStyle(AppPalette.primaryGreen) // antes: Color.blue
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Primary CTA
                    PrimaryButton(title: "Iniciar Sesión") { goToHome = true }

                    // Secondary action demo
                    Button(action: { goToHome = true }) {
                        Text("→ Continuar como invitado (demo)")
                            .font(.system(.footnote, design: .default))
                            .foregroundStyle(AppPalette.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)

                    // Divider
                    DividerLabel(text: "o continuar con")

                    // Social buttons
                    VStack(spacing: 12) {
                        SocialButton(provider: .apple, title: "Continuar con Apple") { goToApple = true }
                        SocialButton(provider: .google, title: "Continuar con Google") { goToGoogle = true }
                    }

                    // Bottom link to register
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?")
                            .foregroundStyle(AppPalette.textSecondary)
                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Regístrate")
                                .foregroundStyle(AppPalette.primaryGreen)
                                .fontWeight(.semibold)
                        }
                        .buttonStyle(.plain)
                    }
                    .font(.system(.footnote, design: .default))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .navigationDestination(isPresented: $goToHome) {
            AlarmView()
        }
        .navigationDestination(isPresented: $goToGoogle) {
            GoogleSignInAccountsView()
        }
        .navigationDestination(isPresented: $goToApple) {
            AppleSignInIntroView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("LoginView") {
    NavigationStack {
        LoginView()
    }
}
