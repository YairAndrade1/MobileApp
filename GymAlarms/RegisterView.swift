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
            AppPalette.backgroundPrimary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Top bar with back
                    HStack {
                        AppBackButton()
                        Spacer()
                    }
                    .padding(.top, 8)

                    // Title & subtitle
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Crear Cuenta")
                            .font(.system(.largeTitle, design: .default, weight: .bold))
                            .foregroundStyle(AppPalette.white)
                        Text("Completa para continuar")
                            .font(.system(.subheadline, design: .default))
                            .foregroundStyle(AppPalette.textSecondary)
                    }

                    // Form
                    VStack(spacing: 16) {
                        LabeledTextField(label: "CORREO ELECTRÓNICO", placeholder: "tu@correo.com", text: $email)
                        LabeledSecureField(label: "CONTRASEÑA", placeholder: "Mínimo 8 caracteres", text: $password)
                        LabeledSecureField(label: "CONFIRMAR CONTRASEÑA", placeholder: "Repite tu contraseña", text: $confirmPassword)
                    }

                    // Primary CTA
                    PrimaryButton(title: "Crear Cuenta") { goToHome = true }

                    // Divider
                    DividerLabel(text: "o registrarse con")

                    // Social buttons
                    VStack(spacing: 12) {
                        SocialButton(provider: .apple, title: "Continuar con Apple") { goToApple = true }
                        SocialButton(provider: .google, title: "Continuar con Google") { goToGoogle = true }
                    }

                    // Bottom link to login
                    HStack(spacing: 4) {
                        Text("¿Ya tienes cuenta?")
                            .foregroundStyle(AppPalette.textSecondary)
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Iniciar Sesión")
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
