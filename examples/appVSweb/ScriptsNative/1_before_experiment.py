import json
import pathlib
import os
import subprocess
import time



path = pathlib.Path(__file__).parent.resolve()

# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    device.shell("settings put system accelerometer_rotation 0")
    device.shell("settings put system user_rotation 0")
    
    experiment = args[0] # can be useful if you want to differentiate actions per subject
    apps = experiment.pre_installed_apps

    subjects_f = open(f'{path}/data/native_subjects.json', 'r')
    subjects = json.loads(subjects_f.read())

    print("Installing experiment apps:")
    for count, app in enumerate(apps):
        print(f"{count+1}. {app}")

        if subjects[app]['to_install']: #Some apps eg yt cannot be installed

            if app in device.get_app_list():
                print(f"Already installed, uninstalling: ", end='')
                device.uninstall(app)
                time.sleep(4)

            print('Installing...', end='', flush=True)
            device.shell(f'am start -a android.intent.action.VIEW -d \'market://details?id={app}\'')
            device.shell('input tap 180 1065')
            time.sleep(5)
            device.shell('input tap 430 520') #FIXME: SOME y+560 (plex, bfmtv, imdb)
            time.sleep(35) #FIXME: SOME FASTER
            print("done")
        else:
            print("Proprietary")        
        # device.clear_app_data(app)

    
