import sys
import json
from os import path, environ as env
from subprocess import Popen, STDOUT, PIPE

with open(path.join(env["DOTPREFSDIR"], 'sublime-text', 'conf', 'Preferences.sublime-settings')) as f:
  assoc = json.load(f)['x_file_assoc'].items()
  args  = [f'--ext {e}' if u is None else f'--uti {u}' for e, u in assoc]
  cmd   = ['duti'] + args + ['--rebuild', 'com.sublimetext.4']

  # Debug
  print(*cmd, end = ' ')
  # ['ping', '-c 4', 'python.org']

  with Popen('duti --help', stdout=PIPE, stderr=STDOUT, shell = True, text=True) as proc:
    while True:
      sys.stdout.write(proc.stdout.readline())

      code = proc.poll()
      if code is not None:
        for out in proc.stdout.readlines():
          sys.stdout.write(out)
        print(code)
        sys.exit(code)
