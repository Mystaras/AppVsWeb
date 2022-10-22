import json
import pathlib
import os
import subprocess
import time


path = pathlib.Path(__file__).parent.resolve()

def monkey_runner(script_path: str, descr: str, monker_runner: str = "/usr/bin/monkeyrunner", monkey_runner_playback: str = "/usr/lib/android-sdk/tools/swt/monkeyrunner/scripts/monkey_playback.py"):
    print(f"MonkeyRunner: {script_path}: {descr}")
    mr = subprocess.run([monker_runner, monkey_runner_playback , f"{path}/../{script_path}"], check=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)

    

def main(device, *args, **kwargs) -> None:
    
    subjects_f = open(f'{path}/data/web_subjects.json', 'r')
    subjects = json.loads(subjects_f.read())

    experiment = args[0] # can be useful if you want to differentiate actions per subject
    current_run: Dict = experiment.get_experiment()
    

    for task in subjects[current_run['path']]["interaction"]:

        print(f'Step {task}: ', end='')
        action, cmd, descr = subjects[current_run['path']]["interaction"][task]

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