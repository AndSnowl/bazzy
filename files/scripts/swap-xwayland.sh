#!/usr/bin/env bash
# Since 2026-10-07 Bazzite ships terra-xorg-x11-server-Xwayland in place of
# Fedora's xorg-x11-server-Xwayland. The Terra package provides the bare
# name but not the arch-qualified `xorg-x11-server-Xwayland(x86-64)`, which
# the Hyprland COPR requires, and it conflicts with the Fedora package, so
# the dnf module cannot resolve hyprland at all.
#
# Swap back to Fedora's Xwayland before the dnf module runs. Once Terra
# adds the missing provide (or Bazzite drops the package), this is a no-op.
set -euo pipefail

terra=terra-xorg-x11-server-Xwayland
rpm -q "$terra" >/dev/null 2>&1 || { echo "$terra not installed, nothing to swap"; exit 0; }

if rpm -q --whatprovides 'xorg-x11-server-Xwayland(x86-64)' >/dev/null 2>&1; then
  echo "$terra already provides xorg-x11-server-Xwayland(x86-64), no swap needed"
  exit 0
fi

dnf5 swap -y "$terra" xorg-x11-server-Xwayland
rpm -q xorg-x11-server-Xwayland
