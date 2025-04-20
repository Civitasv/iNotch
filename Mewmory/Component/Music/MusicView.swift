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

    @State private var isHoveringPrevious = false
    @State private var isHoveringPlayPause = false
    @State private var isHoveringNext = false
    
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
                        Text(musicVm.currentTrack.progressString)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                        ProgressView(value: musicVm.currentTrack.progressPercent, total: 1.0)
                            .tint(Color(.black))
                        Text(musicVm.currentTrack.durationString)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    HStack {
                        Image(systemName: "backward.fill")
                            .frame(width: 20, height: 20)
                            .font(.title3)
                            .padding()
                            .background(Color.primary.opacity(isHoveringPrevious ? 0.3 : 0.1))
                            .clipShape(Circle())
                            .onTapGesture {
                                musicVm.prevTrack()
                            }
                            .onHover { isHovering in
                                withAnimation {
                                    isHoveringPrevious = isHovering
                                }
                            }
                        if #available(macOS 14.0, *) {
                            Image(systemName: musicVm.currentTrack.isPlaying ? "pause.fill" : "play.fill")
                                .frame(width: 25, height: 25)
                                .font(.largeTitle)
                                .padding()
                                .background(Color.primary.opacity(isHoveringPlayPause ? 0.3 : 0.1))
                                .clipShape(Circle())
                                .onTapGesture {
                                    musicVm.playPause()
                                }
                                .onHover { isHovering in
                                    withAnimation {
                                        isHoveringPlayPause = isHovering
                                    }
                                }
                                .contentTransition(.symbolEffect)
                        }
                        else {
                            Image(systemName: musicVm.currentTrack.isPlaying ? "pause.fill" : "play.fill")
                                .frame(width: 25, height: 25)
                                .font(.largeTitle)
                                .padding()
                                .background(Color.primary.opacity(isHoveringPlayPause ? 0.3 : 0.1))
                                .clipShape(Circle())
                                .onTapGesture {
                                    musicVm.playPause()
                                }
                                .onHover { isHovering in
                                    withAnimation(.spring(duration: 0.1)) {
                                        isHoveringPlayPause = isHovering
                                    }
                                }
//                                .animation(.default, value: musicVm.currentTrack.isPlaying)
                        }

                        Image(systemName: "forward.fill")
                            .frame(width: 20, height: 20)
                            .font(.title3)
                            .padding()
                            .background(Color.primary.opacity(isHoveringNext ? 0.3 : 0.1))
                            .clipShape(Circle())
                            .onTapGesture {
                                musicVm.nextTrack()
                            }
                            .onHover { isHovering in
                                withAnimation {
                                    isHoveringNext = isHovering
                                }
                            }
                    }
                    Spacer()
                }
                Spacer()
            }
            .frame(width: 500, height: 200)
            .padding()
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
//    MusicMoreView()
//        .environment(MusicViewModel())
    MusicLessLeftView()
        .environment(MusicViewModel())
        .environment(NotchViewModel())
        .frame(width: 200, height: 200)
}
