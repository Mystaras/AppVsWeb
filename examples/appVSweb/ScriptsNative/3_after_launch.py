# noinspection PyUnusedLocal,PyUnusedLocal
import json
import pathlib
import os
import subprocess
import time

path = pathlib.Path(__file__).parent.resolve()

def monkey_runner(script_path: str, descr: str, monker_runner: str = "/usr/bin/monkeyrunner", monkey_runner_playback: str = "/usr/lib/android-sdk/tools/swt/monkeyrunner/scripts/monkey_playback.py"):
    print(f"MonkeyRunner: {script_path}: {descr}")
    mr = subprocess.run([monker_runner, monkey_runner_playback , f"{path}/../{script_path}"], check=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)


def main(device, *args, **kwargs):

    device.shell("settings put system accelerometer_rotation 0")
    device.shell("settings put system user_rotation 0")

    subjects_f = open(f'{path}/data/native_subjects.json', 'r')
    subjects = json.loads(subjects_f.read())

    current_run = args[3]
    for task in subjects[current_run]["after_launch"]:

        print(f'Step {task}: ', end='')
        action, cmd, descr = subjects[current_run]["after_launch"][task]

        if action == 'mkr':
            monkey_runner(cmd, descr)

        elif action == 'adb':
            print(f"ADB: shell {cmd}: {descr}")
            device.shell(cmd)
            time.sleep(1)

        elif action == 'slp':
            print(f"Wait: {cmd} seconds: {descr}")
            time.sleep(cmd)

        else:
            assert(False)
