// AppleSignInIntroView.swift
// Pantalla 1: Iniciar sesión con Apple (intro)

import SwiftUI

struct AppleSignInIntroView: View {
    private let bg = AppPalette.backgroundPrimary

    @State private var goToScanning: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 20) {
                // Top bar with back (consistent with the rest of the app)
                HStack {
                    AppBackButton()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                // Apple logo + titles
                VStack(spacing: 6) {
                    Image(systemName: "applelogo")
                        .font(.system(size: 48))
                        .foregroundStyle(.white)
                        .frame(height: 75)
                    Text("Iniciar sesión con Apple")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .kerning(-0.5)
                    Text("en GymAlarm")
                        .font(.system(size: 14))
                        .foregroundStyle(AppPalette.textSecondary)
                }

                // Name field (static)
                VStack(alignment: .leading, spacing: 0) {
                    Text("NOMBRE")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppPalette.textSecondary)
                        .padding(.bottom, 2)
                    Text("Miguel Angel")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.10), lineWidth: 1.1)
                        )
                )
                .padding(.horizontal, 24)

                // Email choices card
                VStack(spacing: 0) {
                    HStack {
                        Text("CORREO ELECTRÓNICO")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(AppPalette.textSecondary)
                        Spacer()
                    }
                    .frame(height: 38)
                    .padding(.horizontal, 16)

                    VStack(spacing: 0) {
                        // Compartir mi correo (selected)
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.blue)
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.blue, lineWidth: 1.1)
                                Circle()
                                    .fill(.white)
                                    .frame(width: 8, height: 8)
                            }
                            .frame(width: 20, height: 20)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Compartir mi correo")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.white)
                                Text("miguelangelvergaracastro@icloud.com")
                                    .font(.system(size: 13))
                                    .foregroundStyle(AppPalette.textSecondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 70)
                        .background(Color.blue.opacity(0.08))

                        Divider().background(Color.white.opacity(0.06)).padding(.horizontal, 16)

                        // Ocultar mi correo (unselected)
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1.1)
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Ocultar mi correo")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.white)
                                Text("Se creará un correo anónimo de reenvío")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(AppPalette.textSecondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 70)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.10), lineWidth: 1.1)
                        )
                )
                .padding(.horizontal, 24)

                // Disclaimer
                Text(
                    "Apple solo compartirá tu información con IntervalApp la primera vez que inicie sesión. Consulta las \(Text("políticas de privacidad").foregroundStyle(.blue)) para más información."
                )
                .font(.system(size: 12))
                .foregroundStyle(AppPalette.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
    

                // Continue button
                Button(action: { goToScanning = true }) {
                    Text("Continuar")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)

                Spacer(minLength: 16)
            }
        }
        .navigationDestination(isPresented: $goToScanning) {
            AppleFaceIDScanningView()
        }
    }
}

#Preview("Apple Sign In Intro") {
    AppleSignInIntroView()
}
