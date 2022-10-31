# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    device.shell('pm clear com.android.chrome')
    device.shell("settings put system accelerometer_rotation 0")
    device.shell("settings put system user_rotation 0")
