// GooglePermissionsView.swift
// Pantalla 2: Permisos de acceso

import SwiftUI

struct GooglePermissionsView: View {
    let email: String
    private let bg = AppPalette.backgroundPrimary

    @Environment(\.dismiss) private var dismiss
    @State private var goToLoading: Bool = false

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer(minLength: 16)

                // Green badge top
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppPalette.primaryGreen)
                    Image("icon2")
                }
                .frame(width: 60, height: 60)

                // Row with google icon + email (centered)
                HStack(spacing: 8) {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppPalette.googleBlue)
                        Image(systemName: "globe")
                            .foregroundStyle(AppPalette.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(width: 28, height: 28)
                    Text(email)
                        .font(.system(size: 13))
                        .foregroundStyle(AppPalette.textSecondary)
                    Spacer()
                }
                .frame(height: 28)
                .padding(.horizontal, 24)

                // Heading
                VStack(spacing: 0) {
                    Text("GymAlarm quiere acceder")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(AppPalette.white)
                        .kerning(-0.5)
                    Text("a tu Cuenta de Google")
                        .font(.system(size: 14))
                        .foregroundStyle(AppPalette.textSecondary)
                }

                // Permissions card
                VStack(spacing: 0) {
                    permissionRow(iconColor: AppPalette.googleBlue, title: "Tu nombre y foto de perfil", subtitle: "Para personalizar tu experiencia", iconName: "person.fill")
                    Divider().background(AppPalette.divider05).padding(.horizontal, 16)
                    permissionRow(iconColor: AppPalette.googleBlue, title: "Correo electrónico", subtitle: "Para identificar tu cuenta", iconName: "envelope.fill")
                    Divider().background(AppPalette.divider05).padding(.horizontal, 16)
                    permissionRow(iconColor: AppPalette.partnerGreen, title: "Ningún dato adicional", subtitle: "No accedemos a Gmail, Drive ni calendario", iconName: "lock.fill")
                }
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppPalette.cardFill04)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(AppPalette.stroke08, lineWidth: 1.1)
                        )
                )
                .padding(.horizontal, 24)

                // Disclaimer
                Text("Al continuar, permites que GymAlarm acceda a la información anterior asociada a tu \(Text("Cuenta de Google.").foregroundStyle(.blue))")
                    .font(.system(size: 12))
                    .foregroundStyle(AppPalette.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                // Buttons
                VStack(spacing: 12) {
                    Button(action: { goToLoading = true }) {
                        Text("Permitir")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AppPalette.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(AppPalette.googleBlue)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    Button(action: { dismiss() }) {
                        Text("Cancelar")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(AppPalette.dimWhite55)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .overlay(
                                Capsule()
                                    .stroke(AppPalette.stroke10, lineWidth: 1.1)
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 24)
            }
        }
        .navigationDestination(isPresented: $goToLoading) {
            GoogleLoadingView(email: email)
        }
    }

    @ViewBuilder
    private func permissionRow(iconColor: Color, title: String, subtitle: String, iconName: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 17, style: .continuous)
                .fill(iconColor.opacity(0.10))
                .frame(width: 34, height: 34)
                .overlay(
                    RoundedRectangle(cornerRadius: 17, style: .continuous)
                        .stroke(iconColor.opacity(0.35), lineWidth: 1.1)
                )
                .overlay(
                    Image(systemName: iconName)
                        .foregroundStyle(iconColor)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppPalette.white)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(AppPalette.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(AppPalette.white.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .frame(height: 76)
    }
}

#Preview("Google Permissions") {
    GooglePermissionsView(email: "miguelangelvergaracastro@gmail.com")
}
