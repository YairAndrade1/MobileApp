// ForgotPasswordView.swift
// Password recovery entry screen with email validation states

import SwiftUI

struct ForgotPasswordView: View {
    // Color palette
    private let backgroundPrimary = AppPalette.backgroundPrimary
    private let backgroundSecondary = AppPalette.backgroundSecondary
    private let primaryGreen = AppPalette.primaryGreen
    private let white = AppPalette.white
    private let secondaryGray = AppPalette.textSecondary
    private let dangerRed = Color(red: 1.0, green: 0.27, blue: 0.27)

    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var navigateToInbox: Bool = false
    @State private var goToLogin: Bool = false

    private enum InputState {
        case neutral, valid, invalid
    }

    private var inputState: InputState {
        guard !email.isEmpty else { return .neutral }
        return isValidEmail(email) ? .valid : .invalid
    }

    private func isValidEmail(_ text: String) -> Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    var body: some View {
        ZStack(alignment: .top) {
            backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with back button
                HStack {
                    Button(action: { goToLogin = true }) {
                        ZStack {
                            Color.white.opacity(0.07)
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(white)
                        }
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 16)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Small progress markers
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(primaryGreen)
                                .frame(width: 20, height: 6)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.25))
                                .frame(width: 6, height: 6)
                        }
                        .padding(.horizontal, 24)

                        // Icon (mail)
                        HStack {
                            Image(systemName: "envelope")
                                .font(.system(size: 32, weight: .regular))
                                .foregroundStyle(Color.blue)
                            Spacer()
                        }
                        .padding(.horizontal, 24)

                        // Title + subtitle
                        VStack(alignment: .leading, spacing: 8) {
                            Text("¿Olvidaste tu contraseña?")
                                .font(.system(size: 30, weight: .heavy, design: .default))
                                .foregroundStyle(white)
                                .kerning(-1)
                            Text("Sin problema. Escribe tu correo y te enviaremos un enlace para restablecerla.")
                                .font(.system(.subheadline, design: .default))
                                .foregroundStyle(secondaryGray)
                                .kerning(-0.2)
                        }
                        .padding(.horizontal, 24)

                        // Email field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Correo electrónico".uppercased())
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .foregroundStyle(secondaryGray)
                                .kerning(0.3)

                            HStack(spacing: 10) {
                                // Leading icon box
                                ZStack {
                                    let strokeColor: Color = {
                                        switch inputState {
                                        case .neutral: return secondaryGray.opacity(0.4)
                                        case .valid: return primaryGreen
                                        case .invalid: return dangerRed
                                        }
                                    }()
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(strokeColor, lineWidth: 1.1)
                                        .background(
                                            (inputState == .valid ? primaryGreen.opacity(0.12) : inputState == .invalid ? dangerRed.opacity(0.12) : Color.white.opacity(0.05))
                                        )
                                    Image(systemName: "envelope")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundStyle(strokeColor)
                                }
                                .frame(width: 36, height: 36)

                                // TextField
                                TextField("", text: $email, prompt: Text("example@gmail.com").foregroundColor(AppPalette.textSecondary.opacity(0.5)))
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                                    .disableAutocorrection(true)
                                    .foregroundStyle(white)
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.white.opacity(0.05))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(borderColor(for: inputState), lineWidth: 1.1)
                            )
                        }
                        .padding(.horizontal, 24)

                        if inputState == .invalid {
                            Text("Correo electrónico inválido")
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .foregroundStyle(dangerRed)
                                .padding(.horizontal, 24)
                        }

                        Spacer(minLength: 0)

                        // Expiration info banner
                        HStack(spacing: 8) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.white.opacity(0.03))
                                Image(systemName: "info.circle")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(secondaryGray)
                            }
                            .frame(width: 28, height: 28)

                            Text("El enlace expira en 15 minutos por seguridad")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundStyle(secondaryGray)
                                .kerning(-0.1)

                            Spacer()
                        }
                        .padding(.horizontal, 24)

                        // Primary button
                        Button(action: {
                            navigateToInbox = true
                        }) {
                            Text("Enviar enlace")
                                .font(.system(.headline, design: .default, weight: .bold))
                                .foregroundStyle(Color.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(primaryGreen)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)

                        // Secondary button (text style)
                        Button(action: { dismiss() }) {
                            Text("Volver al inicio de sesión")
                                .font(.system(.subheadline, design: .default))
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 38)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                    }
                    .padding(.top, 8)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToInbox) {
            CheckInboxView(email: email)
        }
        .navigationDestination(isPresented: $goToLogin) {
            LoginView()
        }
        .navigationBarHidden(true)
    }

    private func borderColor(for state: InputState) -> Color {
        switch state {
        case .neutral:
            return Color.white.opacity(0.18)
        case .valid:
            return primaryGreen
        case .invalid:
            return dangerRed
        }
    }
}

#Preview("ForgotPasswordView") {
    ForgotPasswordView()
}
