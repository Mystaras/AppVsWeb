# noinspection PyUnusedLocal
def main(device, *args, **kwargs):
    experiment = args[0] # can be useful if you want to differentiate actions per subject
    current_run: Dict = experiment.get_experiment()
    device.shell(f'pm clear {current_run["path"]}')
