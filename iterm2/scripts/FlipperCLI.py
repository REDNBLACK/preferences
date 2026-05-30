#!/usr/bin/env python3.10
import asyncio
import re
import os
import subprocess
import iterm2

BASE = os.path.dirname(__file__)

"""Base Pane View Config"""
class PaneViewConf(object):
  title = "󱢴  Flipper0"
  icon  = f"{BASE}/Flipper.png"
  badge = ''
  color = iterm2.Color(255, 140, 55)
  bg    = None
  mut   = True

def flipper_session():
  """Check if Flipper Connected to PC and Available"""
  comp = subprocess.run("ls /dev/cu.* | rg -oN 'cu.usbmodemflip_(.+)'", shell=True, capture_output=True)
  if comp.returncode == 0:
    sess = comp.stdout.decode('utf-8').rstrip()
    print(f'[Flipper] Got Session: {sess}')
    return sess
  else:
    print(f'[Flipper] No Session!')
    return None

async def main(connection):
  app  = await iterm2.async_get_app(connection)
  window = app.current_terminal_window

  ###############################
  #######     Helpers         ###
  ###############################
  async def show_alert(message):
    """Show a user notification in `window`"""
    alert = iterm2.Alert(PaneViewConf.title, message, window.window_id)
    await alert.async_run(connection)

  async def new_pane(index=0):
    """Open new pane with Title From Config"""
    tab = await window.async_create_tab(index=index)
    await tab.async_activate()
    await tab.async_set_title(PaneViewConf.title)

    return tab.current_session

  async def exec_in_new_pane(command):
    pane = await new_pane()

    async def customize_and_exec():
      # Set Tab Style (+ Tab Icon)
      change = iterm2.LocalWriteOnlyProfile()
      change.set_tab_color(PaneViewConf.color)
      change.set_use_tab_color(True)
      change.set_status_bar_enabled(False)
      change.set_prompt_before_closing(True)
      if PaneViewConf.icon:
        change.set_icon_mode(iterm2.profile.IconMode.CUSTOM)
        change.set_custom_icon_path(PaneViewConf.icon)
      else:
        change.set_icon_mode(iterm2.profile.IconMode.NONE)

      # Set Badge Style
      change.set_badge_text(PaneViewConf.badge)
      change.set_badge_color(PaneViewConf.color)

      # Set Background Image
      if PaneViewConf.bg:
        change.set_transparency(0.0)
        change.set_blur(False)
        change.set_blend(1.0)
        change.set_background_image_mode(iterm2.profile.BackgroundImageMode.ASPECT_FIT)
        change.set_background_image_location(PaneViewConf.bg)

      # Prevent Editing and Scroll
      if not PaneViewConf.mut:
        change.set_blinking_cursor(False)
        change.set_scrollback_lines(0)
        change.set_mouse_reporting(False)

      await pane.async_set_profile_properties(change)

      # Execute Command and Clear Screen
      await pane.async_send_text(command + '\n')
      await pane.async_inject(b'\x1b' + b']1337;ClearScrollback' + b'\x07')

      return pane

    await asyncio.create_task(customize_and_exec())

    return pane

  ###############################
  #######     Main Logic      ###
  ###############################
  if window is not None:
    sess = flipper_session()
    if sess:
      await exec_in_new_pane(f"sudo cu -l /dev/{sess}")
    else:
      await show_alert("Is Not Connected to PC!")
  else:
    print("[Flipper] No Current Window!")


iterm2.run_until_complete(main)
