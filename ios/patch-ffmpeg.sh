#! /usr/bin/env bash
#
# FFmpeg doesn't support EXT-X-DISCONTINUITY tag in m3u8 streaming.
# There is a workaround discussed in
#     https://github.com/Bilibili/ijkplayer/issues/2874
#
# And we translate patch to solve this issue according to discussion.

FF_ALL_ARCHS_IOS8_SDK="armv7 arm64 i386 x86_64"
FF_ALL_ARCHS=$FF_ALL_ARCHS_IOS8_SDK

function run_patch() {
    echo "Patching $1..."
    patch -u -s -p0 -f $1 < patches/issue-2874.diff
}

function patch_2874() {
    if [ -f "ffmpeg-$1/libavformat/hls.c" ]; then
        run_patch "ffmpeg-$1/libavformat/hls.c"
    else
        echo "Skip patch $1"
    fi
}

function patch_all() {
    for ARCH in $FF_ALL_ARCHS
    do
        patch_2874 $ARCH
    done
}

#----------
patch_all
