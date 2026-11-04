#!/usr/bin/env python3
"""Capture debug-only native app fixtures with Apple's Device Hub CLI.

Build with --dart-define=HINTMASTER_STORE_SCENE=<scene> and install the separate
com.hartvig.develop.hint.master.capture bundle first.
Use Device Hub to select the requested Duo hinge posture before running.
"""
import argparse
import datetime
import json
import pathlib
import struct
import subprocess
import time

BUNDLE = 'com.hartvig.develop.hint.master.capture'
DEVICES = {
    'iphone': ('3A247DB0-D7A3-44EF-A6BE-18C47C9BB620', 'A0F7CD6A-46F3-442A-8BC6-58BD991261E8'),
    'ipad': ('81F05768-30BB-4F49-A05B-07AFF423309B', 'A6CE7762-E05F-46AD-ABBD-F8173210FB75'),
    'duo-outer': ('791B008B-41CC-469F-A937-2C5B22833F04', 'EA8A8BB8-646F-4DA7-850B-B4CEF4A92513'),
    'duo-inner': ('791B008B-41CC-469F-A937-2C5B22833F04', 'A85BFA89-DADC-4C73-9AFE-D47BEE34C861'),
}
SCENES = [('categories', '01-categories'), ('gameplay', '02-guess-word'),
          ('setup', '03-chameleon-setup'), ('role', '04-secret-role'), ('reveal', '05-reveal')]
SIZES = {'iphone': {1206, 2622}, 'ipad': {2064, 2752},
         'duo-outer': {1398, 2034}, 'duo-inner': {2007, 2853}}


def run(*command):
    result = subprocess.run(command, text=True, capture_output=True, timeout=60)
    if result.returncode:
        raise RuntimeError(result.stderr + result.stdout)
    return result.stdout.strip()


def capture(group, scenes):
    device, display = DEVICES[group]
    root = pathlib.Path(__file__).resolve().parents[2]
    output = root / 'docs/store-assets/raw/en-US/screenshot-series' / group
    output.mkdir(parents=True, exist_ok=True)
    container = pathlib.Path(run('xcrun', 'simctl', 'get_app_container', device, BUNDLE, 'data'))
    ready = container / 'tmp/store-scene-ready.json'
    for scene, name in SCENES:
        if scene not in scenes:
            continue
        # This only touches the isolated capture app's own ephemeral ready file.
        ready.unlink(missing_ok=True)
        orientation = 'landscapeRight' if scene == 'gameplay' or group in ['ipad', 'duo-inner'] else 'portrait'
        run('xcrun', 'devicectl', 'device', 'orientation', 'set', '--device', device, orientation)
        run('xcrun', 'devicectl', 'device', 'process', 'launch', '--device', device,
            '--terminate-existing', BUNDLE)
        deadline = time.monotonic() + 45
        while True:
            if ready.exists():
                try:
                    state = json.loads(ready.read_text())
                    if state.get('scene') == scene:
                        break
                except (OSError, json.JSONDecodeError):
                    pass
            if time.monotonic() > deadline:
                raise TimeoutError(f'{group}/{scene}: no ready signal from the actual app')
            time.sleep(.25)
        path = output / f'{name}.png'
        run('xcrun', 'devicectl', 'device', 'capture', 'screenshot', '--device', device,
            '--display-unique-id', display, '--destination', str(path))
        size = struct.unpack('>II', path.read_bytes()[16:24])
        if set(size) != SIZES[group]:
            raise RuntimeError(f'{group}/{scene}: wrong display or dimensions {size}')
        metadata = {'group': group, 'scene': scene, 'display': display,
                    'device': device, 'dimensions': size, 'fixture': state,
                    'captured_at': datetime.datetime.now(datetime.timezone.utc).isoformat(),
                    'capture_tool': 'Apple devicectl / Device Hub'}
        path.with_suffix('.capture.json').write_text(json.dumps(metadata, indent=2))
        print(f'{group}/{name}: {size[0]}x{size[1]} native capture ready', flush=True)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('group', choices=DEVICES)
    parser.add_argument('--scenes', nargs='+', choices=[s[0] for s in SCENES],
                        required=True)
    args = parser.parse_args()
    capture(args.group, args.scenes)
