# Replication package

This is the replication package for the Native vs. Web: Studying the energy consumption for different
application types of video streaming services on Android paper. 


The README for Android Runner can be find [here](./README_AndroidRunner.md). 

Changes have been made to the latest Android Runer version (When to start profiling etc.) to be compatible with the experiments context. Do not fetch updates as it could break functinality.

## Experiments

### Raspberry Pi
You can find information with the overall android requirements and raspbery Pi configuration [here](./docs/rpi_ar_setup.md). Most of the interaction use adb directly instead on MonkeyRunney, thus, the MonkeyRunner dependency can be easily dropped if needed.

### Android Device
The device used for this experiment is a Samsung Galaxy J7 Duo. Detailed information regarding the configuration of the device can be found in the paper.

- Reset device to factory settings
- Developer settings, USB debugging, stay awake enabled
- OEM unlocked
- Notifications disabled
- Device sound set to silent

To connect the device to the raspberry Pi:
```console
$ adb devices # Verify that the device is present (should be lugged in to the Pi)
$ adb tcpip 5555 # Restart the adb server on port 5555
$ adb shell "ip addr show wlan0 | grep -e wlan0$ | cut -d\" \" -f 6 | cut -d/ -f 1" # Show the mobile device IP
$ adb connect <ip>:5555 # Connect to the Android device where <ip> is the ip found in the previous command
```

### Experiment Execution
Under [examples/appVSweb](./examples/appVSweb/) you will find the two config.json files for [Native](./examples/appVSweb/config_native.json) and [Web](./examples/appVSweb/config_web.json) application. 

For each application there is a different folder for the experiment scripts. In the `ScriptsX/data/` forlder you will find `X_subjects.json` files with the subjects and their interactions steps for the experiment. If you wish to extend the experiment to a different device, the input/swipe coordinates will need to be updated to comform with the new device's resolution. 

You can run the experiment (outside this folder) with:
```console
$ python3 AppVsWeb/ AppVsWeb/examples/appVsweb/config_native.json
$ python3 AppVsWeb/ AppVsWeb/examples/appVsweb/config_web.json
```

In case of crash you can use the `--progress` option to continue you experiment. Keep in mind that interactions can be unstable as applications exhibit different behaviour in each run. Specially when installing the `Native` aplications or interacting with the `Web` applications.

## Statistics

The files used for the experiment, as well as the data from the experiments can be found in the [R-Statistics](./R-Statistics/) folder. The [analysis.R](./R-Statistics/analysis.R) file contains the source code to reproduce all figures and statistical tests required for the analysis.

The analysis uses the [full_data.csv](./R-Statistics/data/full_data.csv) file which contains all runs for both application types and blocks. If you reproduce the experiment you can generater it manually from the results yielded by Android Runner or using automation.
