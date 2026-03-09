// GoogleSignInAccountsView.swift
// Pantalla 1: Selección de cuenta de Google

import SwiftUI

struct GoogleSignInAccountsView: View {
    private let bg = AuthPalette.backgroundPrimary

    @Environment(\.dismiss) private var dismiss
    @State private var goToPermissions: Bool = false
    @State private var selectedEmail: String = ""

    // Demo accounts
    private let accounts: [(initials: String, name: String, email: String, color: Color)] = [
        ("CR", "Miguel Angel", "miguelangelvergaracastro@gmail.com", Color(hex: "#4285F4")),
        ("CW", "Andres Moncada", "andresmoncadaroldan@gmail.com", Color(hex: "#34A853"))
    ]

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 0) {
                    // Top bar: Atrás
                    HStack(spacing: 4) {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.blue)
                                Text("Atrás")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(Color.blue)
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            // Mini URL bar
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.white.opacity(0.4))
                                Text("accounts.google.com")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.white.opacity(0.4))
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(Color.white.opacity(0.10), lineWidth: 1.1)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 8)

                            // Google logo
                            Image("googlelogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(.top, 24)

                            // Title & subtitle
                            VStack(spacing: 6) {
                                Text("Iniciar sesión")
                                    .font(.system(size: 24))
                                    .foregroundStyle(AuthPalette.white)
                                Text("Elige una cuenta para continuar en IntervalApp")
                                    .font(.system(size: 15))
                                    .foregroundStyle(AuthPalette.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 24)

                            // Account cards
                            VStack(spacing: 12) {
                                ForEach(accounts, id: \.email) { account in
                                    Button(action: { selectedEmail = account.email; goToPermissions = true }) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(account.color)
                                                Text(account.initials)
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundStyle(.white)
                                            }
                                            .frame(width: 42, height: 42)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(account.name)
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundStyle(AuthPalette.white)
                                                Text(account.email)
                                                    .font(.system(size: 13))
                                                    .foregroundStyle(AuthPalette.textSecondary)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(Color.white.opacity(0.25))
                                        }
                                        .padding(.horizontal, 16)
                                        .frame(height: 74)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(Color.white.opacity(0.04))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                        .stroke(Color.white.opacity(0.07), lineWidth: 1.1)
                                                )
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }

                                // Use another account
                                Button(action: {}) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle().fill(Color.white.opacity(0.06))
                                            Image(systemName: "plus")
                                                .foregroundStyle(Color.white.opacity(0.5))
                                        }
                                        .frame(width: 42, height: 42)

                                        Text("Usar otra cuenta")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color(hex: "#4285F4"))
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 68)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(Color.white.opacity(0.07), lineWidth: 1.1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 24)

                            // Footer links (dummy)
                            HStack(spacing: 16) {
                                Text("Español (España)")
                                Text("Privacidad")
                                Text("Condiciones")
                            }
                            .font(.system(size: 11))
                            .foregroundStyle(AuthPalette.textSecondary)
                            .padding(.top, 32)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationDestination(isPresented: $goToPermissions) {
                GooglePermissionsView(email: selectedEmail)
            }
            .navigationBarHidden(true)
    }
}

#Preview("Google Accounts") {
    GoogleSignInAccountsView()
}
