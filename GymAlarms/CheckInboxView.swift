// CheckInboxView.swift
// Confirmation screen after requesting password reset

import SwiftUI

struct CheckInboxView: View {
    private let backgroundPrimary = AuthPalette.backgroundPrimary
    private let primaryGreen = AuthPalette.primaryGreen
    private let white = AuthPalette.white
    private let secondaryGray = AuthPalette.textSecondary

    @Environment(\.dismiss) private var dismiss
    let email: String
    @State private var secondsRemaining: Int = 59
    @State private var canResend: Bool = false
    @State private var goToLogin: Bool = false

    var body: some View {
        NavigationStack {
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
                            // Progress markers second step highlighted
                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.white.opacity(0.25))
                                    .frame(width: 6, height: 6)
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(primaryGreen)
                                    .frame(width: 20, height: 6)
                            }
                            .padding(.horizontal, 24)

                            // Big green circular mail icon
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                                        .stroke(primaryGreen.opacity(0.3), lineWidth: 1.1)
                                        .background {
                                            primaryGreen.opacity(0.1)
                                                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                                        }
                                    Image(systemName: "envelope.badge")
                                        .font(.system(size: 34, weight: .regular))
                                        .foregroundStyle(primaryGreen)
                                }
                                .frame(width: 80, height: 80)
                                Spacer()
                            }
                            .padding(.horizontal, 24)

                            // Title
                            Text("Revisa tu bandeja de entrada")
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .foregroundStyle(white)
                                .kerning(-1)
                                .padding(.horizontal, 24)

                            // Subtitle and email chip
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Enviamos un enlace de recuperación a:")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundStyle(secondaryGray)
                                    .kerning(-0.2)

                                HStack(spacing: 10) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(primaryGreen.opacity(0.2), lineWidth: 1.1)
                                            .background {
                                                primaryGreen.opacity(0.07)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            }
                                        Image(systemName: "envelope")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundStyle(primaryGreen)
                                    }
                                    .frame(width: 28, height: 28)

                                    Text(email)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundStyle(primaryGreen)
                                        .kerning(-0.2)

                                    Spacer()
                                }
                                .frame(height: 44)
                                .padding(.horizontal, 14)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(primaryGreen.opacity(0.2), lineWidth: 1.1)
                                        .background(
                                            primaryGreen.opacity(0.07)
                                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .padding(.horizontal, 24)

                            // Steps card
                            VStack(alignment: .leading, spacing: 12) {
                                stepRow(number: 1, text: "Abre el correo que te enviamos")
                                stepRow(number: 2, text: "Toca el enlace «Restablecer contraseña»")
                                stepRow(number: 3, text: "Crea una nueva contraseña segura")
                            }
                            .padding(16)
                            .background {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1.1)
                                    .background(
                                        Color.white.opacity(0.04)
                                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    )
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.horizontal, 24)

                            Spacer(minLength: 0)

                            // Primary button
                            Button(action: { goToLogin = true }) {
                                Text("Volver al inicio de sesión")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(primaryGreen)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 24)

                            // Resend disabled with countdown
                            Button(action: { /* trigger resend */ }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundStyle(secondaryGray)
                                    Text(canResend ? "Reenviar" : "Reenviar en \(secondsRemaining)s")
                                        .font(.system(.subheadline, design: .rounded))
                                        .foregroundStyle(secondaryGray)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 23, style: .continuous)
                                        .stroke(Color.white.opacity(0.18), lineWidth: 1.1)
                                )
                                .opacity(canResend ? 1.0 : 0.5)
                            }
                            .disabled(!canResend)
                            .buttonStyle(.plain)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 16)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goToLogin) {
                LoginView()
            }
        }
        .onAppear(perform: startCountdown)
    }

    private func startCountdown() {
        canResend = false
        secondsRemaining = 59
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timer.invalidate()
                canResend = true
            }
        }
    }

    @ViewBuilder
    private func stepRow(number: Int, text: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(primaryGreen.opacity(0.25), lineWidth: 1.1)
                    .background {
                        primaryGreen.opacity(0.12)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                Text("\(number)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(primaryGreen)
            }
            .frame(width: 24, height: 24)

            Text(text)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color(red: 0.83, green: 0.83, blue: 0.81))
                .kerning(-0.2)
            Spacer()
        }
    }
}

#Preview("CheckInboxView") {
    CheckInboxView(email: "miguelangelvergara@gmail.com")
}
