// AlarmExecutionView.swift
// Premium, dark, minimal execution screen for a training timer

import SwiftUI

// MARK: - Domain
private enum Phase {
    case work
    case rest
}

// MARK: - AlarmExecutionView
struct AlarmExecutionView: View {
    // State
    @Environment(\.dismiss) private var dismiss

    @State private var totalSets: Int = 3
    @State private var currentSet: Int = 1
    @State private var phase: Phase = .work

    @State private var workDuration: TimeInterval = 45
    @State private var restDuration: TimeInterval = 20

    @State private var remaining: TimeInterval = 45
    @State private var totalPhaseDuration: TimeInterval = 45

    @State private var isPaused: Bool = false

    // Timer simulation
    @State private var timer: Timer?

    // Navigation to summary
    @State private var goToSummary: Bool = false

    // Accumulators for summary
    @State private var accumulatedWork: TimeInterval = 0
    @State private var accumulatedRest: TimeInterval = 0

    // Layout metrics
    @ScaledMetric(relativeTo: .largeTitle) private var ringSize: CGFloat = 280
    @ScaledMetric private var ringLineWidth: CGFloat = 18
    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let headerTopPadding: CGFloat = 12
        static let headerBottomSpacing: CGFloat = 12
        static let controlsBottomPadding: CGFloat = 24
    }

    var body: some View {
        ZStack {
            AppPalette.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header sin botón custom; se usará el botón nativo del sistema
                ExecutionHeaderView(currentSet: currentSet, totalSets: totalSets)
                    .padding(.top, Layout.headerTopPadding)
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.bottom, Layout.headerBottomSpacing)

                // Title by phase
                Text(phase == .work ? "Tiempo de Trabajo" : "Tiempo de Descanso")
                    .font(.system(.largeTitle, design: .default, weight: .bold))
                    .foregroundStyle(phase == .work ? AppPalette.primaryGreen : AppPalette.restBlue)
                    .padding(.bottom, 10)

                // Sets indicator
                SetProgressIndicator(total: totalSets, current: currentSet)
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.bottom, 8)

                Spacer(minLength: 12)

                // Progress Ring
                ProgressRingView(
                    size: ringSize,
                    lineWidth: ringLineWidth,
                    progress: progress,
                    trackColor: phase == .work ? AppPalette.primaryGreen.opacity(0.22) : AppPalette.restTrack,
                    progressColor: phase == .work ? AppPalette.primaryGreen : AppPalette.restBlue,
                    timeText: timeFormatted(remaining),
                    labelText: phase == .work ? "TRABAJO" : "DESCANSO"
                )
                .padding(.vertical, 8)

                Spacer()

                // Divider subtle
                Rectangle()
                    .fill(AppPalette.white.opacity(0.12))
                    .frame(height: 1)
                    .opacity(0.6)
                    .padding(.horizontal, Layout.horizontalPadding)

                // Controls
                ExecutionControlsView(
                    isPaused: isPaused,
                    primaryColor: phase == .work ? AppPalette.primaryGreen : AppPalette.restBlue,
                    onBack15: { remaining = min(totalPhaseDuration, remaining + 15) },
                    onTogglePlayPause: togglePause,
                    onForward15OrNext: { adjustTime(by: 15) },
                    onSkipPhase: { advancePhase() }
                )
                .padding(.top, 12)
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.controlsBottomPadding)
            }
        }
        .onAppear { startPhase(.work, set: 1) }
        .onDisappear { invalidateTimer() }
        .animation(.easeInOut(duration: 0.25), value: phase)
        .animation(.easeInOut(duration: 0.25), value: currentSet)
        // Aseguramos que el botón nativo esté disponible
        .navigationBarBackButtonHidden(false)
        .navigationDestination(isPresented: $goToSummary) {
            AlarmSummaryView(
                totalTime: timeFormatted(accumulatedWork + accumulatedRest),
                workTime: timeFormatted(accumulatedWork),
                restTime: timeFormatted(accumulatedRest),
                setCount: totalSets,
                subtitleText: "\(totalSets) series completadas"
            )
        }
    }

    private var progress: Double {
        guard totalPhaseDuration > 0 else { return 0 }
        let done = totalPhaseDuration - remaining
        return max(0, min(1, done / totalPhaseDuration))
    }

    // MARK: - Phase Control
    private func startPhase(_ newPhase: Phase, set: Int) {
        phase = newPhase
        currentSet = set
        totalPhaseDuration = (newPhase == .work) ? workDuration : restDuration
        remaining = totalPhaseDuration
        isPaused = false
        startTimer()
    }

    private func startTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard !isPaused else { return }
            tick()
        }
    }

    private func tick() {
        if remaining > 0 {
            remaining -= 1
        } else {
            if phase == .work {
                accumulatedWork += workDuration
            } else {
                accumulatedRest += restDuration
            }
            advancePhase()
        }
    }

    private func advancePhase() {
        switch phase {
        case .work:
            startPhase(.rest, set: currentSet)
        case .rest:
            if currentSet < totalSets {
                startPhase(.work, set: currentSet + 1)
            } else {
                isPaused = true
                invalidateTimer()
                goToSummary = true
            }
        }
    }

    private func togglePause() {
        isPaused.toggle()
        if !isPaused, timer == nil { startTimer() }
    }

    private func adjustTime(by delta: TimeInterval) {
        if delta < 0 {
            remaining = max(0, remaining + delta)
        } else {
            if remaining - delta <= 0 {
                remaining = 0
                if phase == .work {
                    accumulatedWork += totalPhaseDuration
                } else {
                    accumulatedRest += totalPhaseDuration
                }
                advancePhase()
            } else {
                remaining -= delta
            }
        }
    }

    private func timeFormatted(_ seconds: TimeInterval) -> String {
        let s = Int(max(0, seconds))
        let mPart = s / 60
        let sPart = s % 60
        return String(format: "%02d:%02d", mPart, sPart)
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - ExecutionHeaderView
private struct ExecutionHeaderView: View {
    let currentSet: Int
    let totalSets: Int

    var body: some View {
        HStack(alignment: .center) {
            Spacer()

            HStack(spacing: 8) {
                Text("Serie \(currentSet) / \(totalSets)")
                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                    .foregroundStyle(AppPalette.white.opacity(0.75))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(AppPalette.white.opacity(0.09))
                            .overlay(
                                Capsule()
                                    .stroke(AppPalette.white.opacity(0.12), lineWidth: 1)
                            )
                    )
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - SetProgressIndicator
private struct SetProgressIndicator: View {
    let total: Int
    let current: Int

    private enum Metrics {
        static let heightInactive: CGFloat = 6
        static let heightActive: CGFloat = 8
        static let widthInactive: CGFloat = 20
        static let widthActive: CGFloat = 38
        static let spacing: CGFloat = 8
    }

    var body: some View {
        HStack(spacing: Metrics.spacing) {
            ForEach(1...total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? AppPalette.white : AppPalette.white.opacity(0.10))
                    .frame(width: index == current ? Metrics.widthActive : Metrics.widthInactive,
                           height: index == current ? Metrics.heightActive : Metrics.heightInactive)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - ProgressRingView
private struct ProgressRingView: View {
    let size: CGFloat
    let lineWidth: CGFloat
    let progress: Double // 0...1
    let trackColor: Color
    let progressColor: Color
    let timeText: String
    let labelText: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(trackColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .opacity(0.6)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
                .animation(.easeInOut(duration: 0.25), value: progress)

            VStack(spacing: 6) {
                Text(timeText)
                    .font(.system(size: size * 0.18, weight: .bold, design: .rounded))
                    .foregroundStyle(AppPalette.white)
                    .monospacedDigit()
                Text(labelText)
                    .font(.system(.footnote, design: .rounded, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(AppPalette.white.opacity(0.45))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Progreso")
        .accessibilityValue("\(Int(progress * 100)) por ciento")
    }
}

// MARK: - ExecutionControlsView
private struct ExecutionControlsView: View {
    let isPaused: Bool
    let primaryColor: Color
    let onBack15: () -> Void
    let onTogglePlayPause: () -> Void
    let onForward15OrNext: () -> Void
    let onSkipPhase: () -> Void

    private enum Metrics {
        static let buttonSize: CGFloat = 68
        static let iconSize: CGFloat = 22
        static let spacing: CGFloat = 22
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: Metrics.spacing) {
                CircleButton(style: .secondary, size: Metrics.buttonSize, iconSize: Metrics.iconSize, iconName: "gobackward.15", color: primaryColor, action: onBack15)

                CircleButton(style: .primary, size: Metrics.buttonSize + 10, iconSize: Metrics.iconSize + 2, iconName: isPaused ? "play.fill" : "pause.fill", color: primaryColor, action: onTogglePlayPause)

                CircleButton(style: .secondary, size: Metrics.buttonSize, iconSize: Metrics.iconSize, iconName: "goforward.15", color: primaryColor, action: onForward15OrNext)
            }
            Button(action: onSkipPhase) {
                Text("Saltar fase")
                    .font(.system(.footnote, design: .default))
                    .foregroundStyle(primaryColor.opacity(0.6))
                    .padding(.top, 2)
            }
            .buttonStyle(.plain)
        }
    }
}

private enum CircleButtonStyleKind { case primary, secondary }

private struct CircleButton: View {
    let style: CircleButtonStyleKind
    let size: CGFloat
    let iconSize: CGFloat
    let iconName: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundStyle(style == .primary ? Color.black : AppPalette.white.opacity(0.75))
                .frame(width: size, height: size)
                .background(
                    Group {
                        if style == .primary {
                            Circle().fill(color)
                        } else {
                            Circle()
                                .fill(AppPalette.white.opacity(0.06))
                                .overlay(Circle().stroke(AppPalette.white.opacity(0.12), lineWidth: 1))
                        }
                    }
                )
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
    }
}

// MARK: - Preview
#Preview("AlarmExecutionView") {
    NavigationStack {
        AlarmExecutionView()
    }
}
