import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var goToApple: Bool = false
    @State private var goToGoogle: Bool = false
    @State private var goToHome: Bool = false

    var body: some View {
        ZStack {
            AuthPalette.backgroundPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Top bar with back
                    HStack {
                        AuthBackButton()
                        Spacer()
                    }
                    .padding(.top, 8)

                    // Title & subtitle
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Crear Cuenta")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .foregroundStyle(AuthPalette.white)
                        Text("Completa para continuar")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(AuthPalette.textSecondary)
                    }

                    // Form
                    VStack(spacing: 16) {
                        AuthTextField(label: "CORREO ELECTRÓNICO", placeholder: "tu@correo.com", text: $email)
                        AuthSecureField(label: "CONTRASEÑA", placeholder: "Mínimo 8 caracteres", text: $password)
                        AuthSecureField(label: "CONFIRMAR CONTRASEÑA", placeholder: "Repite tu contraseña", text: $confirmPassword)
                    }

                    // Hidden NavigationLink to AlarmView
                    NavigationLink(destination: AlarmView(), isActive: $goToHome) {
                        EmptyView()
                    }
                    .hidden()

                    // Primary CTA
                    PrimaryAuthButton(title: "Crear Cuenta") { goToHome = true }

                    // Divider
                    AuthDivider(text: "o registrarse con")

                    // Social buttons
                    VStack(spacing: 12) {
                        SocialAuthButton(provider: .apple, title: "Continuar con Apple") { goToApple = true }
                        SocialAuthButton(provider: .google, title: "Continuar con Google") { goToGoogle = true }
                    }

                    // Bottom link to login
                    HStack(spacing: 4) {
                        Text("¿Ya tienes cuenta?")
                            .foregroundStyle(AuthPalette.textSecondary)
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Iniciar Sesión")
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
        .navigationDestination(isPresented: $goToApple) {
            AppleSignInIntroView()
        }
        .navigationDestination(isPresented: $goToGoogle) {
            GoogleSignInAccountsView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("RegisterView") {
    NavigationStack {
        RegisterView()
    }
}

