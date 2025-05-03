//
//  NotchView.swift
//  iNotch
//
//  Created by 胡森 on 2025/4/16.
//

import SwiftUI
import Defaults
import Foundation

private struct NotchPanelKey: EnvironmentKey {
    static let defaultValue: NSPanel? = nil
}
 
extension EnvironmentValues { /// Search notchPanel in Environment
  var notchPanel: NSPanel? {
    get { self[NotchPanelKey.self] }
    set { self[NotchPanelKey.self] = newValue }
  }
}

class NotchPanel<Content: View>: NSPanel {
    @Binding var bPresented: Bool
    init(view: () -> Content,
         contentRect: NSRect,
         backing: NSWindow.BackingStoreType = .buffered,
         defer flag: Bool = false,
         bPresented: Binding<Bool>
    ) {
        /// Initialize the binding variable by assigning the whole value via an underscore
        self._bPresented = bPresented
     
        /// Init the window as usual
        super.init(contentRect: contentRect,
                   styleMask: [.nonactivatingPanel, .borderless, .utilityWindow, .hudWindow],
                   backing: backing,
                   defer: flag)
     
        /// Allow the panel to be on top of other windows
        isFloatingPanel = true
        level = .mainMenu + 3
        isOpaque = false
     
        /// Allow the pannel to be overlaid in a fullscreen space
        collectionBehavior.insert(.fullScreenAuxiliary)
        collectionBehavior.insert(.stationary)
        collectionBehavior.insert(.canJoinAllSpaces)
        collectionBehavior.insert(.ignoresCycle)
     
        /// Don't show a window title, even if it's set
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        isReleasedWhenClosed = false
        backgroundColor = .clear
     
        /// It stays on the top
        isMovable = false
     
        /// Hide all traffic light buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
     
        /// Sets animations accordingly
        animationBehavior = .utilityWindow
        
        /// No shadow
        hasShadow = false
     
        /// Set the content view.
        /// The safe area is ignored because the title bar still interferes with the geometry
        contentView = NSHostingView(rootView: view() /// view lives inside NotchPanel
            .ignoresSafeArea()
            .environment(\.notchPanel, self)) /// use @Environment(\.notchPanel) to get this environment object
    }

    /// Close automatically when out of focus, e.g. outside click
    override func resignMain() {
        super.resignMain()
        close()
    }
     
    /// Close and toggle presentation, so that it matches the current state of the panel
    override func close() {
        super.close()
        bPresented = false
    }

    override var canBecomeKey: Bool {
        return false
    }
     
    override var canBecomeMain: Bool {
        return false
    }
}

/// Add a  ``NotchPanel`` to a view hierarchy
fileprivate struct NotchPanelModifier<PanelContent: View>: ViewModifier {
    /// Determines wheter the panel should be presented or not
    @Binding var bPresented: Bool
 
    /// Determines the starting size of the panel
    var contentRect: CGRect = CGRect(x: 0, y: 0, width: 610, height: 200)
 
    /// Holds the panel content's view closure
    @ViewBuilder let view: () -> PanelContent
 
    /// Stores the panel instance with the same generic type as the view closure
    @State var panel: NotchPanel<PanelContent>?
 
    func body(content: Content) -> some View {
        content
            .onAppear {
                /// When the view appears, create, center and present the panel if ordered
                panel = NotchPanel(view: view, contentRect: contentRect, bPresented: $bPresented)
//                panel?.center()
                if bPresented {
                    present()
                }
            }.onDisappear {
                /// When the view disappears, close and kill the panel
                panel?.close()
                panel = nil
            }.onChange(of: bPresented) { old_value, new_value in
                /// On change of the presentation state, make the panel react accordingly
                if new_value {
                    present()
                } else {
                    panel?.close()
                }
            }
    }
 
    /// Present the panel and make it the key window
    func present() {
        panel?.alphaValue = 0
        panel?.orderFrontRegardless()
        panel?.makeKey()
        /// change Panel location
        if let screen = NSScreen.main {
            Logger.log("screen valid", category: .debug)
            let panel_width: CGFloat = contentRect.width
            let panel_height: CGFloat = contentRect.height
            let screen_width: CGFloat = screen.frame.width
            let screen_height: CGFloat = screen.frame.height
            let scree_origin_x: CGFloat = screen.frame.origin.x
            let scree_origin_y: CGFloat = screen.frame.origin.y
            let origin = NSPoint(
                x: scree_origin_x + (screen_width / 2) - panel_width / 2,
                y: scree_origin_y + screen_height - panel_height
            )
            panel?.setFrameOrigin(origin)
            panel?.alphaValue = 1
            Logger.log("\(panel_width) . \(panel_height) . \(screen_width) . \(screen_height) . \(scree_origin_x) . \(scree_origin_y)", category: .debug)
        }
        else {
            Logger.log("screen invalid", category: .debug)
        }
    }
}

extension View {
    /** Present a ``NotchPanel`` in SwiftUI fashion
     - Parameter isPresented: A boolean binding that keeps track of the panel's presentation state
     - Parameter contentRect: The initial content frame of the window
     - Parameter content: The displayed content
     **/
    func notchPanel<Content: View>(bPresented: Binding<Bool>,
                                  contentRect: CGRect = CGRect(x: 0, y: 0, width: 610, height: 200),
                                  @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(NotchPanelModifier(bPresented: bPresented, contentRect: contentRect, view: content))
    }
}

// The Root View
struct NotchView: View {
    // 整个空间的最大大小，即浮动之后的大小
    @State private var notchPanelRect: CGRect = CGRect(x: 0, y: 0, width: 610, height: 200)

    @State var bPresented = true
    

    var body: some View {
        SettingView()
        .notchPanel(bPresented: $bPresented, contentRect: notchPanelRect, content: {
            ContentView(notchPanelRect: notchPanelRect)
        })
    }
}

// The View Inside Notch
struct ContentView: View {
    @State private var notchVm = NotchViewModel()
    
    @State private var keyboardVm = KeyboardViewModel()
    @State private var cpuVm = SystemViewModel()
    @State private var musicVm = MusicViewModel()
    @State private var batteryVm = BatteryViewModel()
    @State private var soundVm = SoundAdjustingViewModel()
    @State private var message = "Swipe right to reveal"
    
    #if DEBUG
    @Default(.showGM) var showGM
    #endif
    
    var notchPanelRect: CGRect
    private var notchSize = getClosedNotchSize()
    
    var body: some View {
        ZStack(alignment: .top) {
            NotchShape()
                .fill(.black)
                .shadow(color: notchVm.bHovering ? .black.opacity(0.6): .clear, radius: 5)
                .onScrollWheelUp { deltaX, deltaY in
                    notchVm.shrinkOrExpand(deltaX: deltaX, deltaY: deltaY)
                }
                .gesture(TapGesture(count: 2).onEnded {
                    notchVm.doubleTap()
                })
                .frame(width: notchVm.notchViewSize.width, height: notchVm.notchViewSize.height, alignment: .top)
                .onHover(perform: { hovering in
                    let bHovering = hovering
                    Logger.log("Hovering Start: \(bHovering)", category: .ui)
                    withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
                        notchVm.bHovering = bHovering
                        notchVm.refreshSize()
                    }
                    Logger.log("Hovering End: \(notchVm.bHovering)", category: .ui)
                })
            
            #if DEBUG
            if ProcessInfo.processInfo.isSwiftUIPreview {
                if notchVm.displayMode == .More {
                    ZStack(alignment: .top) {
                        VStack (alignment: .center) {
                            MusicMoreView()
                                .frame(alignment: .center)
                        }
                    }
                    .padding(10)
                    .frame(width: notchVm.notchViewSize.width - 20, height: notchVm.notchViewSize.height)
                }
                else {
                    if notchVm.showVolume {
                        
                    } else {
                        ZStack(alignment: .top) {
                            MusicLessLeftView()
                                .frame(maxWidth: .infinity, maxHeight: notchSize.height, alignment: .leading)
                            MusicLessRightView()
                                .frame(maxWidth: .infinity, maxHeight: notchSize.height, alignment: .trailing)
                        }
                        .frame(width: notchVm.notchViewSize.width - 20, height: notchSize.height) // 高度不变，宽度随实际宽度改变而改变
                    }
                }
            }
            #endif
            if notchVm.displayMode == .More {
                ZStack(alignment: .top) {
                    if let fullComponent = notchVm.currentSnapShot.fullComponent {
                        fullComponent.content
                            .frame(alignment: .center)
                    }
                }
                .padding(10)
                .frame(width: notchVm.notchViewSize.width - 20, height: notchVm.notchViewSize.height)
            }
            else {
                if notchVm.showTips {
                    Text(LocalizedStringResource(stringLiteral: notchVm.tips))
                        .foregroundStyle(.white)
                        .frame(width: notchVm.notchViewSize.width - 20, height: notchSize.height)
                        .position(x: (notchPanelRect.width) / 2, y: (notchVm.notchViewSize.height + notchSize.height) / 2)
                }
                else if notchVm.showKeyPanel {
                    KeyboardView()
                        .frame(width: notchVm.notchViewSize.width - 20, height: notchSize.height)
                        .position(x: (notchPanelRect.width) / 2, y: (notchVm.notchViewSize.height + notchSize.height) / 2)
                }
                ZStack(alignment: .top) {
                    if notchVm.showVolume {
                        SoundLeftView()
                            .frame(maxWidth: .infinity, maxHeight: notchSize.height, alignment: .leading)
                        SoundRightView()
                            .frame(maxWidth: .infinity, maxHeight: notchSize.height, alignment: .trailing)
                    }
                    else {
                        if let leftComponent = notchVm.currentSnapShot.leftComponent {
                            leftComponent.content
                                .frame(maxWidth: .infinity, maxHeight: notchSize.height, alignment: .leading)
                        }
                        
                        if let rightComponent = notchVm.currentSnapShot.rightComponent {
                            rightComponent.content
                                .frame(maxWidth: .infinity, maxHeight: notchSize.height, alignment: .trailing)
                        }
                    }
                }
                .frame(width: notchVm.notchViewSize.width-20, height: notchSize.height) // 高度不变，宽度随实际宽度改变而改变
            }
        }
        .environment(\.locale, .init(identifier: "zh-Hans"))
        .environment(keyboardVm)
        .environment(musicVm)
        .environment(notchVm)
        .environment(soundVm)
        .frame(maxWidth: notchPanelRect.width, maxHeight: notchPanelRect.height, alignment: .top) // 与最大宽度和高度一致
    }
    
    init(notchPanelRect: CGRect) {
        self.notchPanelRect = notchPanelRect
    }
}

#Preview {
    ContentView(notchPanelRect: CGRect(x: 0, y: 0, width: 610, height: 200))
        .frame(width: 800, height: 300, alignment: .top)
        .environment(NotchViewModel())
        .environment(MusicViewModel())
        .environment(KeyboardViewModel())
        .environment(SystemViewModel())
}
