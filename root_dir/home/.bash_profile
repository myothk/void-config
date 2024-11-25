# .bash_profile
clear
# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

# Only launches sway in tty1
if [[ $(tty) == "/dev/tty1" ]]
then
    export XDG_CURRENT_DESKTOP=sway
    export EDITOR=nvim

# QT apps fix
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QT_QPA_PLATFORM="wayland"
    export QT_WAYLAND_FORCE_DPI=physical
    export QT_QTA_PLATFORMTHEME="qt5ct:qt6ct"

# Wayland variables
#   export ELM_DISPLAY=wl
#   export SDL_VIDEODRIVER=wayland

# WLR variables
#    export WLR_RENDERER=vulkan #gles2,pixman,vulkan ref https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md
    export WLR_DRM_DEVICES=$(readlink -f /dev/dri/by-path/pci-0000\:00\:02.0-card)              # device for drm.
#    export WLR_NO_HARDWARE_CURSORS=1

# GLX, EGL, HARDWARE ACCELERATION variables
# System works fine without editing. eglinfo reports GBM, Wayland, EGL platforms work.
# Only edit if needed. 
    export __NV_PRIME_RENDER_OFFLOAD=0

    export __GLX_VENDOR_LIBRARY_NAME=mesa         # mesa, nvidia. Defaults to mesa if undefined
    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json	# prevent loading nvidia drivers at sway launch,
   export LIBVA_DRIVER_NAME=iHD	# i965, iHD. vaapi driver override of /usr/lib64/dri/driver_drv_dri.so
#   export XWAYLAND_NO_GLAMOR=0	#1 falls back to llvmpipe, 0 still uses mesa
#   export GBM_BACKEND=nvidia-drm           # IDK why but uncommenting this causes firefox to exit with segmentation fault. 

    umask 0027
    exec dbus-run-session sway --unsupported-gpu

fi
