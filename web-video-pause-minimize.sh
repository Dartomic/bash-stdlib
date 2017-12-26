#!/bin/bash
# global function to pause a running Youtube in Conkeror
# TODO: add for other browsers
# get current window
# TODO: actually time this and find something that goes faster, takes about 2-3s? but at least it minimizes first
# TODO: case sensitive/insensitive search
CURRENTWINDOW=$(xdotool getwindowfocus)
CURRENTYOUTUBE=
# TODO minimize all windows first
xdotool search --onlyvisible --name "twitch|youtube" | while IFS= read -r line; do
    if xdotool search --class conkeror | grep "${line}" >/dev/null; then
        xdotool windowminimize "${line}"
    fi
done
xdotool search --class "Fceux|zsnes|PCSXR|PPSSPPSDL" | while IFS= read -r line; do
    # now go through rest of potential websites
    # TODO: eventually just flip them off without muting
    # TODO: eventually have restore for all of these
    xdotool windowminimize "${line}"
    amixer set Master mute
done
# turn off youtube even if not visible
xdotool search --name "twitch|youtube" | while IFS= read -r line; do
    if xdotool search --class conkeror | grep "${line}" >/dev/null; then
        xdotool windowfocus --sync "${line}";
        # TODO: very arbitrary delay, perhaps wait for something to return
        sleep 0.05
        ${HOME}/bin/conkeror-batch -f web-video-pause
        if [[ "${line}" == "${CURRENTWINDOW}" ]]; then
            CURRENTYOUTUBE=1
        fi
    fi
done
# restore focus if not youtube window
# XXXX only need for youtube because I focused to use pause api
if [[ -n "$CURRENTYOUTUBE" ]]; then
    xdotool windowactivate --sync ${CURRENTWINDOW}
fi