# Replication package
The README for Android Runner can be find [here](./README_AndroidRunner.md). 

Changes have been made to the latest Android Runer version (When to start profiling etc.) to be compatible with the experiments context. Do not fetch updates as it could break functinality.

## Experiments

### Raspberry Pi
You can find information with the overall android requirements and raspbery Pi configuration [here](./docs/rpi_ar_setup.md).

### Android Device
The device used for this experiment is a Samsung Galaxy J7 Duo. Detailed information regarding the configuration of the device can be found in the report.

### Experiment Execution
Under [examples/appVSweb](./examples/appVSweb/) you will find the two config.json files for [Native](./examples/appVSweb/config_native.json) and [Web](./examples/appVSweb/config_web.json) application. 

For each application there is a different folder for the experiment scripts. In the `ScriptsX/data/` forlder you will find `X_subjects.json` files with the subjects and their interactions steps for the experiment. If you wish to extend the experiment to a different device, the input/swipe coordinates will need to be updated to comform with the new device's resolution. 

You can run the experiment (outside this folder) with:
```
python3 AppVsWeb/ AppVsWeb/examples.appVsweb/config_native.json
python3 AppVsWeb/ AppVsWeb/examples.appVsweb/config_web.json
```

In case of crash you can use the `--progress` option to continue you experiment. Keep in mind that interactions can be unstable as applications exhibit different behaviour in each run. Specially when installing the `Native` aplications or interacting with the `Web` applications.

## Statistics

The files used for the experiment, as well as the data from the experiments can be found in the [R-Statistics](./R-Statistics/) folder. The [analysis.R](./R-Statistics/analysis.R) file contains the source code to reproduce all figures and statistical tests required for the analysis.

The analysis uses the [full_data.csv](./R-Statistics/data/full_data.csv) file which contains all runs for both application types and blocks. If you reproduce the experiment you can generater it manually from the results yielded by Android Runner or using automation.
