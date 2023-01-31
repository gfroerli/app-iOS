//
//  UndimmedSheet.swift
//  gfroerli
//
//  Created by Marc on 30.01.23.
//
//  Code from: https://danielsaidi.com/blog/2022/06/21/undimmed-presentation-detents-in-swiftui

import Foundation
import SwiftUI

public enum UndimmedPresentationDetent {

    case large
    case medium

    case fraction(_ value: CGFloat)
    case height(_ value: CGFloat)

    var swiftUIDetent: PresentationDetent {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case let .fraction(value): return .fraction(value)
        case let .height(value): return .height(value)
        }
    }

    var uiKitIdentifier: UISheetPresentationController.Detent.Identifier {
        switch self {
        case .large: return .large
        case .medium: return .medium
        case let .fraction(value): return .fraction(value)
        case let .height(value): return .height(value)
        }
    }
}

public extension UISheetPresentationController.Detent.Identifier {

    static func fraction(_ value: CGFloat) -> Self {
        .init("Fraction:\(String(format: "%.1f", value))")
    }

    static func height(_ value: CGFloat) -> Self {
        .init("Height:\(value)")
    }
}

public extension Collection where Element == UndimmedPresentationDetent {

    var swiftUISet: Set<PresentationDetent> {
        Set(map { $0.swiftUIDetent })
    }
}

public extension View {

    func presentationDetents(
        undimmed detents: [UndimmedPresentationDetent],
        largestUndimmed: UndimmedPresentationDetent? = nil
    ) -> some View {
        background(UndimmedDetentView(largestUndimmed: largestUndimmed ?? detents.last))
            .presentationDetents(detents.swiftUISet)
    }

    func presentationDetents(
        undimmed detents: [UndimmedPresentationDetent],
        largestUndimmed: UndimmedPresentationDetent? = nil,
        selection: Binding<PresentationDetent>
    ) -> some View {
        background(UndimmedDetentView(largestUndimmed: largestUndimmed ?? detents.last))
            .presentationDetents(
                Set(detents.swiftUISet),
                selection: selection
            )
    }
}

public struct UndimmedDetentView: UIViewControllerRepresentable {

    var largestUndimmed: UndimmedPresentationDetent?

    public func makeUIViewController(context: Context) -> UIViewController {
        let result = UndimmedDetentController()
        result.largestUndimmed = largestUndimmed
        return result
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

public class UndimmedDetentController: UIViewController {

    var largestUndimmed: UndimmedPresentationDetent?

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avoidDimmingParent()
        avoidDisablingControls()
    }

    func avoidDimmingParent() {
        let id = largestUndimmed?.uiKitIdentifier
        sheetPresentationController?.largestUndimmedDetentIdentifier = id
    }

    func avoidDisablingControls() {
        presentingViewController?.view.tintAdjustmentMode = .normal
    }
}
