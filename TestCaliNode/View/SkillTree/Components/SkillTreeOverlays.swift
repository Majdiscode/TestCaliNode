//
//  SkillTreeOverlays.swift
//  TestCaliNode
//
//  Overlay Modifier for confirmations/errors
//  CREATE this file in: View/SkillTree/Components/SkillTreeOverlays.swift
//

import SwiftUI

struct SkillTreeOverlays: ViewModifier {
    let showCard: Bool
    let pendingSkill: SkillNode?
    let prereqMessage: String?
    let onConfirm: () -> Void
    let onCancel: () -> Void
    let onDismissError: () -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if showCard, let skill = pendingSkill {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .overlay(
                                ConfirmationCardView(
                                    prompt: skill.confirmPrompt,
                                    confirmAction: onConfirm,
                                    cancelAction: onCancel
                                )
                            )
                            .zIndex(10)
                    } else if let message = prereqMessage {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .overlay(
                                CenteredErrorMessage(
                                    message: message,
                                    onDismiss: onDismissError
                                )
                            )
                            .zIndex(9)
                    }
                }
            )
    }
}

// MARK: - View Extension
extension View {
    func skillTreeOverlays(
        showCard: Bool,
        pendingSkill: SkillNode?,
        prereqMessage: String?,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void,
        onDismissError: @escaping () -> Void
    ) -> some View {
        modifier(SkillTreeOverlays(
            showCard: showCard,
            pendingSkill: pendingSkill,
            prereqMessage: prereqMessage,
            onConfirm: onConfirm,
            onCancel: onCancel,
            onDismissError: onDismissError
        ))
    }
}
