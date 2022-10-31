import json
import pathlib
import os
import subprocess
import time

path = pathlib.Path(__file__).parent.resolve()

# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    experiment = args[0] # can be useful if you want to differentiate actions per subject
    apps = experiment.pre_installed_apps

    subjects_f = open(f'{path}/data/native_subjects.json', 'r')
    subjects = json.loads(subjects_f.read())

    print("Uninstalling experiment apps:")
    for count, app in enumerate(apps):
        if subjects[app]['to_install']: #Some apps eg youtube, facebook are default
            print(f"{count+1}. {app}")

            if app in device.get_app_list():
                device.uninstall(app)

    device.shell("settings put system user_rotation 0")
    device.shell("settings put system accelerometer_rotation 1")
