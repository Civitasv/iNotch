//
//  MusicView.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/19.
//

import SwiftUI
import Defaults

struct MusicLessLeftView: View {
    @Environment(MusicViewModel.self) var musicVm
    @Environment(NotchViewModel.self) var notchVm
    @Namespace var albumArtNamespace

    private var notchSize = getClosedNotchSize()

    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .background(
                Image(nsImage: musicVm.currentTrack.artwork ?? NSImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 4.0))
            .matchedGeometryEffect(id: "albumArt", in: albumArtNamespace)
            .frame(width: max(0, notchSize.height - 12), height: max(0, notchSize.height - 12), alignment: .center)
    }
}

struct MusicLessRightView: View {
    @Environment(MusicViewModel.self) var musicVm
    @Environment(NotchViewModel.self) var notchVm
    @Default(.useMusicVisualizer) var useMusicVisualizer
    @Default(.coloredSpectrogram) var coloredSpectrogram
    @Namespace var albumArtNamespace

    private var notchSize = getClosedNotchSize()

    var body: some View {
        if useMusicVisualizer {
            Rectangle()
                .fill(coloredSpectrogram ? Color(nsColor: musicVm.currentTrack.avgColor) : Color.gray)
                .frame(width: 50, alignment: .center)
                .matchedGeometryEffect(id: "spectrum", in: albumArtNamespace)
                .mask {
                    AudioSpectrumView()
                        .frame(width: 16, height: 12)
                }
                .frame(width: max(0, notchSize.height - 12),
                       height: max(0, notchSize.height - 12), alignment: .center)
        }
    }
}

struct MusicMoreView: View {
    @Environment(MusicViewModel.self) var musicVm
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Menu {
                Button {
                    musicVm.openAppleMusic()
                } label: {
                    Text("Open AppleMusic")
                    Image(systemName: "play.house")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
            .menuIndicator(.hidden)
            .menuStyle(.borderlessButton)
            .frame(width: 25, height: 20)
            .padding()
            
            HStack {
                ZStack(alignment: .center) {
                    if let coverImage = musicVm.currentTrack.artwork {
                        CoverImageView(image: Image(nsImage: coverImage), album: musicVm.currentTrack.album)
                    }
                    else {
                        CoverImageView(image: Image("IconSettings"), album: musicVm.currentTrack.album)
                    }
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    Text(musicVm.currentTrack.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .animation(.default, value: musicVm.currentTrack)
                    Text(musicVm.currentTrack.artist)
                        .font(.title3)
                        .foregroundStyle(Color.gray)
                        .animation(.default, value: musicVm.currentTrack)
                    HStack {
                        TimelineView(.animation(minimumInterval: nil)) { timeline in
                            MusicSliderView() { newValue in
                                musicVm.seek(pos: newValue)
                            }
                            .padding(.top, 5)
                            .frame(height: 36)
                        }
                    }
                    HStack {
                        HoverButton(icon: "backward.fill", scale: .medium) {
                            musicVm.prevTrack()
                        }
                        HoverButton(icon: musicVm.currentTrack.isPlaying ? "pause.fill" : "play.fill", scale: .large) {
                            musicVm.playPause()
                        }
                        HoverButton(icon: "forward.fill", scale: .medium) {
                            musicVm.nextTrack()
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct MusicSliderView: View {
    @Environment(MusicViewModel.self) var musicVm

    @State private var sliderValue: Double = 0
    @State private var dragging: Bool = false
    
    var onValueChange: (Double) -> Void

    var body: some View {
        VStack {
            CustomSlider(
                value: $sliderValue,
                dragging: $dragging,
                range: 0 ... musicVm.currentTrack.duration,
                color: Color(nsColor: musicVm.currentTrack.avgColor).ensureMinimumBrightness(factor: 0.8),
                onValueChange: onValueChange
            )
            .frame(height: 10, alignment: .center)
            HStack {
                Text(musicVm.currentTrack.progressString)
                Spacer()
                Text(musicVm.currentTrack.durationString)
            }
            .fontWeight(.medium)
            .foregroundColor(Color(nsColor: musicVm.currentTrack.avgColor).ensureMinimumBrightness(factor: 0.6))
            .font(.caption)
        }
        .onChange(of: musicVm.currentTrack.progress) { _, _ in
            guard !dragging else { return }
            sliderValue = musicVm.currentTrack.progress
        }
    }
}

struct CustomSlider: View {
    @Binding var value: Double
    @Binding var dragging: Bool
    var range: ClosedRange<Double>
    var color: Color = .white
    var onValueChange: ((Double) -> Void)?

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = CGFloat(dragging ? 9 : 5)
            let rangeSpan = range.upperBound - range.lowerBound

            let filledTrackWidth = min(rangeSpan == .zero ? 0 : ((value - range.lowerBound) / rangeSpan) * width, width)

            ZStack(alignment: .leading) {
                // Background track
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: height)

                // Filled track
                Rectangle()
                    .fill(color)
                    .frame(width: filledTrackWidth, height: height)
            }
            .cornerRadius(height / 2)
            .frame(height: 10)
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        withAnimation {
                            dragging = true
                        }
                        let newValue = range.lowerBound + Double(gesture.location.x / width) * rangeSpan
                        value = min(max(newValue, range.lowerBound), range.upperBound)
                    }
                    .onEnded { _ in
                        onValueChange?(value)
                        dragging = false
                    }
            )
            .animation(.bouncy.speed(1.4), value: dragging)
        }
    }
}

private struct HoverButton: View {
    var icon: String
    var iconColor: Color = .white;
    var scale: Image.Scale = .medium
    var action: () -> Void
    var contentTransition: ContentTransition = .symbolEffect;
    
    @State private var isHovering = false

    var body: some View {
        let size = CGFloat(scale == .large ? 40 : 30)
        
        Button(action: action) {
            Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .frame(width: size, height: size)
                .overlay {
                    Capsule()
                        .fill(isHovering ? Color.gray.opacity(0.2) : .clear)
                        .frame(width: size, height: size)
                        .overlay {
                            Image(systemName: icon)
                                .foregroundColor(iconColor)
                                .contentTransition(contentTransition)
                                .font(scale == .large ? .largeTitle : .body)
                        }
                }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.smooth(duration: 0.3)) {
                isHovering = hovering
            }
        }
    }
}


private struct CoverImageView: View {
    @State private var shouldShowAlbumName = false
    
    let image: Image
    let album: String?
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .blur(radius: 100)
                .offset(x: 0, y: 5)
                .opacity(shouldShowAlbumName ? 0.3 : 1)
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .blur(radius: 20)
                .offset(x: 0, y: 5)
                .opacity(shouldShowAlbumName ? 0.3 : 1)
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(shouldShowAlbumName ? 0.3 : 1)
            
            if let album = album {
                Text(album)
                    .padding()
                    .font(.body)
                    .minimumScaleFactor(0.8)
                    .shadow(color: Color.black, radius: 3)
                    .opacity(shouldShowAlbumName ? 1 : 0)
            }
        }
        .onHover { isHovering in
            withAnimation {
                shouldShowAlbumName = isHovering
            }
        }
        .animation(.default, value: image)
    }
}

#Preview {
    MusicMoreView()
        .environment(MusicViewModel())
//    MusicLessLeftView()
//        .environment(MusicViewModel())
//        .environment(NotchViewModel())
//        .frame(width: 200, height: 200)
}
