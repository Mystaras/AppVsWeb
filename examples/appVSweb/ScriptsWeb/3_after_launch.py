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
    # Tap coordinates can be found by enabling 'Pointer location' in Developer options
    # Accept Chrome policy prompts
    device.shell('input tap 355 1075') #once in a while
    time.sleep(0.5)
    device.shell('input tap 355 1190')
    time.sleep(0.5)
    device.shell('input tap 115 1210')
    time.sleep(0.5)
    
    # Enable permissions for Chrome
    # device.shell('pm grant com.android.chrome android.permission.RECORD_AUDIO')
    # device.shell('pm grant com.android.chrome android.permission.CAMERA')
    # device.shell('pm grant com.android.chrome android.permission.WRITE_EXTERNAL_STORAGE')
    # device.shell('pm grant com.android.chrome android.permission.READ_EXTERNAL_STORAGE')

    device.shell("settings put system accelerometer_rotation 0")
    device.shell("settings put system user_rotation 0")

    subjects_f = open(f'{path}/data/web_subjects.json', 'r')
    subjects = json.loads(subjects_f.read())

    experiment = args[2] # can be useful if you want to differentiate actions per subject
    current_run: Dict = experiment.get_experiment()
    

    for task in subjects[current_run['path']]["after_launch"]:

        print(f'Step {task}: ', end='')
        action, cmd, descr = subjects[current_run['path']]["after_launch"][task]

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
