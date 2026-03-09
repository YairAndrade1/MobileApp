// SaveAlarmSheet.swift
// Reusable compact bottom sheet for saving an alarm

import SwiftUI

public struct SaveAlarmSheet: View {
    // Bindings
    @Binding var name: String
    @Binding var isSaving: Bool
    @Binding var isPresented: Bool

    // Styling palette (align with app)
    private enum Palette {
        static let background = Color(hex: "071416")
        static let card = Color(hex: "0D2226")
        static let border = Color(hex: "FFFFFF", alpha: 0.12)
        static let white = Color(hex: "FFFFFF")
        static let white60 = Color(hex: "FFFFFF", alpha: 0.60)
        static let white28 = Color(hex: "FFFFFF", alpha: 0.28)
        static let green = Color(hex: "BDFF00")
    }

    // Actions
    let onSave: () -> Void

    public init(name: Binding<String>, isSaving: Binding<Bool>, isPresented: Binding<Bool>, onSave: @escaping () -> Void) {
        self._name = name
        self._isSaving = isSaving
        self._isPresented = isPresented
        self.onSave = onSave
    }

    public var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text("Guardar Alarma")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Palette.white)
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Palette.white)
                        .frame(width: 28, height: 28)
                        .background(Palette.card)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Palette.border, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("NOMBRE DE LA ALARMA")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                    .foregroundStyle(Palette.white60)
                TextField("Ingresa el nombre de tu alarma", text: $name)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Palette.card)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Palette.border, lineWidth: 1))
                    )
                    .foregroundStyle(Palette.white)
            }

            Button(action: onSave) {
                HStack(spacing: 8) {
                    if isSaving { ProgressView().tint(Color.black) }
                    Text("Guardar")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Palette.green)
                .clipShape(Capsule())
            }
            .disabled(isSaving || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Palette.background)
    }
}

// Local hex helper
private extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hexSanitized.count {
        case 3: (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: alpha)
    }
}
