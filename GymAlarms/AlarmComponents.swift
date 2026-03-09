import SwiftUI

// MARK: - AdjustableMetricCard
struct AdjustableMetricCard: View {
    let title: String
    let valueText: String
    let onDecrement: () -> Void
    let onIncrement: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .default))
                    .foregroundStyle(AuthPalette.textSecondary)
                Spacer()
            }

            HStack(alignment: .center) {
                CircleButton(symbol: "minus", action: onDecrement)
                Spacer()
                Text(valueText)
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundStyle(AuthPalette.white)
                Spacer()
                CircleButton(symbol: "plus", action: onIncrement)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.04))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct CircleButton: View {
    let symbol: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(symbol == "plus" ? AuthPalette.primaryGreen : AuthPalette.white)
                .frame(width: 40, height: 40)
                .background(
                    (symbol == "plus" ? AuthPalette.primaryGreen.opacity(0.12) : AuthPalette.white.opacity(0.08))
                )
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(AuthPalette.fieldBorder, lineWidth: 1)
                        .background(
                            Circle().fill(symbol == "plus" ? AuthPalette.primaryGreen.opacity(0.12) : AuthPalette.white.opacity(0.08))
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - SummaryCard
struct SummaryCard: View {
    let sets: Int
    let work: String
    let rest: String
    let total: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RESUMEN")
                .font(.system(.caption, design: .default, weight: .semibold))
                .foregroundStyle(AuthPalette.textSecondary)

            HStack(spacing: 12) {
                SummaryItem(title: "SETS", value: "\(sets)")
                SummaryItem(title: "TRABAJO", value: work)
                SummaryItem(title: "DESCANSO", value: rest)
                SummaryItem(title: "TOTAL", value: total)
            }
            .padding(14)
            .background(Color.white.opacity(0.04))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

private struct SummaryItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundStyle(AuthPalette.primaryGreen)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(AuthPalette.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Bottom Navigation Bar
struct BottomNavBar: View {
    enum Tab { case saved, alarm, recents, settings }
    var active: Tab

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(AuthPalette.fieldBorder)
                .frame(height: 1)
                .opacity(1)
            HStack(spacing: 0) {
                BottomNavItem(iconName: "tabSaved", title: "Guardados", isActive: active == .saved)
                BottomNavItem(iconName: "tabAlarm", title: "Alarma", isActive: active == .alarm)
                BottomNavItem(iconName: "tabRecents", title: "Recientes", isActive: active == .recents)
                BottomNavItem(iconName: "tabSettings", title: "Ajustes", isActive: active == .settings)
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 10)
            .background(AuthPalette.backgroundPrimary.ignoresSafeArea(edges: .bottom))
        }
    }
}

struct BottomNavItem: View {
    let iconName: String
    let title: String
    let isActive: Bool

    var body: some View {
        VStack(spacing: 4) {
            Group {
                if UIImage(named: iconName) != nil {
                    Image(iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "square")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 22, height: 22)
            .foregroundStyle(isActive ? AuthPalette.primaryGreen : AuthPalette.textSecondary)
            Text(title)
                .font(.system(size: 11, weight: .semibold, design: .default))
                .foregroundStyle(isActive ? AuthPalette.primaryGreen : AuthPalette.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

// MARK: - Save Alarm Sheet
struct SaveAlarmSheet: View {
    @Binding var name: String
    var isSaving: Bool
    var onClose: () -> Void
    var onSave: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Handle
            Capsule()
                .fill(AuthPalette.fieldBorder)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            HStack(alignment: .center) {
                Text("Guardar Alarma")
                    .font(.system(.headline, design: .default, weight: .semibold))
                    .foregroundStyle(AuthPalette.white)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AuthPalette.white)
                        .frame(width: 28, height: 28)
                        .background(AuthPalette.backgroundPrimary.opacity(0.6))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(AuthPalette.fieldBorder, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 10) {
                Text("NOMBRE DE LA ALARMA")
                    .font(.system(size: 12, weight: .semibold, design: .default))
                    .foregroundStyle(AuthPalette.textSecondary)
                TextField("Ingresa el nombre de tu alarma", text: $name)
                    .textInputAutocapitalization(.words)
                    .font(.system(.body, design: .default))
                    .padding(.vertical, 14)
                    .padding(.horizontal, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AuthPalette.fieldBorder, lineWidth: 1)
                            .background(AuthPalette.backgroundSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    )
                    .foregroundStyle(AuthPalette.white)
            }
            .padding(.horizontal, 16)

            Button(action: onSave) {
                HStack(spacing: 8) {
                    if isSaving { ProgressView().tint(.black) }
                    Text(isSaving ? "Guardando..." : "Guardar")
                        .font(.system(size: 17, weight: .semibold, design: .default))
                }
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AuthPalette.primaryGreen)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .padding(.top, 4)
        .background(AuthPalette.backgroundSecondary)
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Save Success Modal
struct SaveSuccessModal: View {
    let title: String
    let message: String
    var onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AuthPalette.primaryGreen)
                        .frame(width: 56, height: 56)
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.black)
                }
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundStyle(AuthPalette.white)
                Text(message)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundStyle(AuthPalette.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 12)

                Button(action: onConfirm) {
                    Text("Perfecto")
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AuthPalette.primaryGreen)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(AuthPalette.backgroundSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AuthPalette.fieldBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal, 28)
        }
    }
}

#Preview("Alarm Components") {
    VStack(spacing: 24) {
        AdjustableMetricCard(title: "NÚMERO DE SETS", valueText: "3", onDecrement: {}, onIncrement: {})
        SummaryCard(sets: 3, work: "0:45", rest: "0:20", total: "3:15")
        BottomNavBar(active: .alarm)
        SaveAlarmSheet(name: .constant("Press Banca"), isSaving: false, onClose: {}, onSave: {})
    }
    .padding()
    .background(AuthPalette.backgroundPrimary)
}
