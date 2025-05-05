//
//  Event.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/19.
//

import Foundation
import SwiftUI
import Combine

private var cancellables = Set<AnyCancellable>()

enum Signal: String {
    case Test = "test"
}

func postEvent(name: String, params: [AnyHashable : Any]? = nil) {
    NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: params)
}

func registerEvent(name: String, handler: @escaping ([AnyHashable: Any]?) -> Void) {
    NotificationCenter.default.publisher(for: Notification.Name(name))
        .sink { notification in
            handler(notification.userInfo)
        }
        .store(in: &cancellables)
}

extension View {
    /// 监听自定义通知的修饰符
    /// - Parameters:
    ///   - name: 遵循 RawRepresentable 协议的通知类型
    ///   - handler: 收到通知时的处理闭包
    func registerEvent<NotificationType: RawRepresentable>(
        _ name: NotificationType,
        handler: @escaping ([AnyHashable: Any]?) -> Void
    ) -> some View where NotificationType.RawValue == String {
        self.modifier(NotificationReceiverModifier(
            notificationName: name,
            handler: handler
        ))
    }
}

struct NotificationReceiverModifier<NotificationType: RawRepresentable>: ViewModifier where NotificationType.RawValue == String {
    let notificationName: NotificationType
    let handler: ([AnyHashable: Any]?) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(
                for: Notification.Name(notificationName.rawValue)
            )) { notification in
                handler(notification.userInfo)
            }
    }
}
