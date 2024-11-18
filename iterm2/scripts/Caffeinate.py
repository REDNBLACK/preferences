#!/usr/bin/env python3.10
import asyncio
import re
import subprocess
import iterm2

def running():
  process = subprocess.Popen(["pgrep", "caffeinate"], stdout=subprocess.PIPE)
  (output, err) = process.communicate()
  exit_code = process.wait()
  return output.decode('utf-8').rstrip()

async def open_pane_and_start_service(window, command):
  tab = await window.async_create_tab(index=0)
  await tab.async_activate()
  session = tab.current_session
  pane  = session

  async def run_fs():
    # Set Title
    await tab.async_set_title(' NO SLEEP')

    # Set Tab
    change = iterm2.LocalWriteOnlyProfile()
    change.set_tab_color(iterm2.Color(129, 51, 129))
    change.set_use_tab_color(True)
    change.set_status_bar_enabled(False)
    change.set_prompt_before_closing(True)

    # Set Badge
    change.set_badge_text('')
    change.set_badge_color(iterm2.Color(129, 51, 129))

    # Set Background Image
    change.set_transparency(0.0)
    change.set_blur(False)
    change.set_blend(1.0)
    change.set_background_image_mode(iterm2.profile.BackgroundImageMode.ASPECT_FIT)
    change.set_background_image_location('/Users/rb/Preferences/iterm2/scripts/Caffeinate.png')
    change.set_icon_mode(iterm2.profile.IconMode.NONE)

    # Prevent Editing and Scroll
    change.set_blinking_cursor(False)
    change.set_scrollback_lines(0)
    change.set_mouse_reporting(False)

    await pane.async_set_profile_properties(change)
    await pane.async_send_text(command + '\n')
    await pane.async_inject(b'\x1b' + b']1337;ClearScrollback' + b'\x07')

    return pane

  loop = asyncio.get_event_loop()
  task = loop.create_task(run_fs())
  await task

  return pane

async def main(connection):
  app  = await iterm2.async_get_app(connection)
  window = app.current_terminal_window

  if window is not None:
    pid = running()
    print(f'Running PID: {pid}')

    if pid:
      print(f'Already running Caffeinate: {pid}')

      for window in app.windows:
        for tab in window.tabs:
          for session in tab.sessions:
            found = await session.async_get_variable("jobName")
            print(f'Found Process: {found}')

            if found == "caffeinate":
              print(f'Found is Caffeinate: {found} <-> {pid}')
              await session.async_activate()
              return
    else:
      caffeinate = await open_pane_and_start_service(window, "caffeinate -d")
  else:
    print("No current window")


iterm2.run_until_complete(main)
