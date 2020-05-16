from os.path import join

configfile: 'config.yml'

SRC_DIR = "src"
DATA_DIR = "data"
RAW_DIR = join(DATA_DIR, "raw")
PROC_DIR = join(DATA_DIR, "processed")

print(config.items())

rule all:
    input:
        [ join(PROC_DIR, "{}", "{}.flat.json").format(instance, dataset_id)
            for instance, instance_datasets in config.items()
            for dataset_id in instance_datasets ],
        # Files for the current set manager
        [ join(PROC_DIR, "{}", "{}.factors.json").format(instance, dataset_id)
            for instance, instance_datasets in config.items()
            for dataset_id in instance_datasets ],

rule process_dataset_flat:
    input:
        join(RAW_DIR, "{instance}.csv")
    output:
        join(PROC_DIR, "{instance}", "{dataset_id}.flat.json")
    script:
        join(SRC_DIR, "process_dataset_flat.py")

rule process_dataset_tree:
    input:
        join(RAW_DIR, "{instance}.csv")
    output:
        join(PROC_DIR, "{instance}", "{dataset_id}.tree.json")
    script:
        join(SRC_DIR, "process_dataset_tree.py")

rule process_dataset_factors:
    input:
        join(RAW_DIR, "{instance}.csv")
    output:
        join(PROC_DIR, "{instance}", "{dataset_id}.factors.json")
    script:
        join(SRC_DIR, "process_dataset_factors.py")