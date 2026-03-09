import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var goToForgot: Bool = false
    @State private var goToGoogle: Bool = false
    @State private var goToApple: Bool = false
    @State private var goToHome: Bool = false

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
                            NavigationLink {
                                ForgotPasswordView()
                            } label: {
                                Text("¿Olvidaste tu contraseña?")
                                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Color.blue)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Hidden NavigationLink to AlarmView
                    NavigationLink(destination: AlarmView(), isActive: $goToHome) {
                        EmptyView()
                    }
                    .hidden()

                    // Primary CTA
                    PrimaryAuthButton(title: "Iniciar Sesión") { goToHome = true }

                    // Secondary action demo
                    Button(action: { goToHome = true }) {
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
                        SocialAuthButton(provider: .apple, title: "Continuar con Apple") { goToApple = true }
                        SocialAuthButton(provider: .google, title: "Continuar con Google") { goToGoogle = true }
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
