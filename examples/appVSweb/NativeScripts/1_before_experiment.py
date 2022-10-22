# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    experiment = args[0] # can be useful if you want to differentiate actions per subject
    apps = experiment.pre_installed_apps

    for app in apps:
        device.shell(f'pm clear {app}')

    device.shell("settings put system accelerometer_rotation 0")
    device.shell("settings put system user_rotation 0")
