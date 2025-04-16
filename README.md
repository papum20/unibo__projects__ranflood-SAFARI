<img style="float:right;" src="icon.png?raw=true" width="25%">

# SAFARI
The Scalable Air-gapped Framework for Automated Ransomware Investigation (SAFARI) platform.  


## Disclaimers

This project works with ransomwares, stored locally (usually zipped and protected by a password), transferred to the target machine, unzipped and executed there (optionally after disabling network interfaces).  
Launching the ansible playbooks through `launch-ansible.sh` optionally downloads a zipped ransomware.  


## Files

*	`ansible/` : ansible playbooks executed on the remote machines
	*	`checker/` : checker playbooks
	*	`files/` : files to transfer to the hosts
		*	`checker/` : files to transfer to the hosts, in the remote working dir (for the filechecker)
		*	`other/` : other files, currently unused
			*	`vc_runtime140_1.dll` : already present on VM windows-java-21
		*	`prepopulate/` : files needed to prepopulate the system
		*	`ranflood/` : files to transfer to the hosts, in the ranflood dir
		*	`ransomwares/` : collection of ransomwares - only one will be transferred to the target machines
		*	`transfer/` : files to transfer to the hosts, in the remote working dir
			*	`ranflood.bat` : convenience link to executable
			*	`ranfloodd.bat` : launches daemon through java - a bat script allows to identify and kill the process
	*	`playbooks/` : example playbooks for some uses
		*	`tasks/` : lists of tasks used in the (external) playbooks
	*	`variables/` : variables (refer to [configuration](#configuration))
	*	`full_playbook.yml` : playbook run on this machine
	*	`internal_playbook_java.yml` : like `internal_playbook.yml`, but with the java version of ranflood
	*	`internal_playbook.yml` : playbook transferred and run on the target machines
*	`doc/` : notes
*	`out/` : outputs and logs (refer to [output](#output))
*	`scripts/` : scripts to launch the project or interact with the rig, proxmox etc. (refer to [scripts](#scripts))
*	`terraform/` : terraform scripts to deploy the infrastructure
	*	`checker/` : checker scripts


## Usage

1.	initialize the configuration (refer to [initialization](#initialization));
2.	you can use the provided scripts; here are the main ones, from the most automated one to the most detailed one (refer to their own section below) :
	*	[test-ransomware.sh](#test-ransomwaresh) : 
	*	[launch-both-retry.sh](#launch-both-retrysh) :
	*	[launch-both.sh](#launch-bothsh) :
	*	[launch.sh](#launchsh) :


### Scripts

All scripts are located in the `scripts/` directory, and should be launched from the project's root directory; e.g.:
```bash
./scripts/launch.sh
```

For more information, consult their help message in the files, or print it (flag `-h`).   

To launch terraform alone, basically go in the correct folder (either `terraform/` or `terraform/checker/`) and run:
```bash
terraform init
terraform apply
```
To launch ansible alone (on infected machines) :
```bash
./scripts/launch-ansible.sh
```
Or, for the filechecker :
```bash
./scripts/launch-ansible.sh -c
```

#### SAFARI

##### launch.sh
```
./scripts/launch.sh [--c|-checker] [-d|--delete] [-D|--destroy] [-l LOG_FILE] [-h|--help]"
```
Launch the terraform provisioner (before) and the ansible playbooks (after), on the remote hosts, either for:
*	target VM to infect : destroy previous VMs, create new ones and launch the tests, with ansible, on them; also, will update checker's terraform variables with the disks to check :
	```bash
	./scripts/launch.sh
	```
*	filechecker : run the filechecker, on the infected VMs' disks :
	```bash
	./scripts/launch.sh -c
	```

Each (of the two) terraform provisioner will create, in its directory, a `vm.txt` file, containing information about the created VMs (IPs, IDs, disks for the infected ones).  

Other parameters:
*	`-d` : delete VM after
*	`-D` : only delete VM
*	`-l LOG_FILE` : log to file
*	`-m` : manual mode, i.e. don't provision with terraform (which would destroy and recreate) (also refer to [troubleshooting](#troubleshooting))

##### launch-both.sh
Basically (plus some setup) :
```bash
./scripts/launch.sh && \
	./scripts/launch.sh -c
```

Optionally, run more tests with the current setup; e.g.:
```bash
./scripts/launch-bot.sh 10
```

##### launch-both-retry.sh
Like [launch-both.sh](#launch-bothsh), but retry until the specified number of tests has been completed successfully; e.g.:  
```bash
./scripts/launch-both-retry.sh 10
```

##### test-ransomware.sh
A wrapper for [launch-both-retry.sh](#launch-both-retrysh), with the additional conveniences of :
*	automatically setting some parameters (ransomware to test, number of shards)
*	running the tests until the desired number is obtained
*	collecting all tests in a subfolder (named after the parameteres)

e.g., for `WannaCry` with 60 shards and 10 tests :
```bash
./scripts/test-ransomware.sh Ransomware.WannaCry 60 10
# tests will end up in 'out/ansible/Ransomware.WannaCry/60s-10shards/'
```
This is the most automated script, so can be called in sequence to obtain all the desired tests (an example is in [group-tests.sh](#examples)).  

##### additional scripts
*	`./scripts/launch_workaround.sh` : like `launch.sh`, but with a workaround for some old bugs, which have been probably been fixed now.  


#### analyzer

Basically, to upload a full ransomware's folder, with the checksum in `./scripts/analyzer/res/cleanWindowsChecksum_filtered.json`, use :
```bash
./scripts/analyzer/upload-one.sh LOCAL_FOLDER_PATH REMOTE_FOLDER_NAME RANSOMWARE
```

*	`./scripts/analyzer/upload-one.sh` : upload the full folder of a test batch
*	`./scripts/analyzer/upload.sh` : upload a single file
*	`scripts/analyzer/res/` : additional files and examples
	*	`./scripts/analyzer/res/cleanWindowsChecksum*` : a checksum is required for the analyzer scripts; this is the one used in these tests, but could be changed
	*	`./scripts/analyzer/res/cleanWindowsChecksum.json` : the base one
	*	`./scripts/analyzer/res/cleanWindowsChecksum_filtered.json` : with some filters
	*	`./scripts/analyzer/res/cleanWindowsChecksum_no_appdata.json` : removed `AppData`
	*	`./scripts/analyzer/res/convert*.py` : example scripts used to filter the checksum

Multiple test batches can be uploaded with a sequence of invocations of `upload-one.sh` (example in [group-uploads.sh](#examples)).  

#### examples

Examples of launching multiple commands in succession :
*	`./scripts/examples/group-tests.sh` : run multiple tests in succession
*	`./scripts/examples/group-uploads_old.sh` : upload multiple tests to the analyzer (an older version, more hard-coded)
*	`./scripts/examples/group-uploads.sh` : upload multiple tests to the analyzer

#### python

*	`./scripts/python/average.py` : calculate averages and stats for a test batch, from the detailed SSS reports
*	`./scripts/python/report-flatten-filter.py` : process an SSS report so that it can be used by the analyzer

#### util

`ssh` and `scp` scripts only work with 1 VM, reading its info from the appropriate `vm.txt` file.  

*	`./scripts/util/generate.sh` : auto-generate variables files
*	`.scripts/util/out-count-results.sh` : count checker results (report files) in the specified folder, not recursive (i.e. search the files recursively in all and only subfolders, of the specified one, in the form of an IP)
*	`./scripts/util/read-vms.sh` : read data of the VMs generated with SAFARI's terraform scripts, and export them as variables
*	`.scripts/util/ssh-checker-check.sh` : launch an internal check in checker
*	`.scripts/util/ssh-checker.sh` : ssh in checker
*	`.scripts/util/ssh-scp-checker-out.sh` : scp from checker
*	`.scripts/util/ssh-scp-checker-to.sh` : scp to checker
*	`.scripts/util/ssh-windows.sh` : ssh in windows
*	`./scripts/util/vm-status.sh` : change proxmox vm status (through API)


### Configuration

*	`ansible/variables/variables_[external|internal].yml` : external/internal playbook
*	`ansible/variables/variables.sh` : most of ansible variables
*	also see the list of secret files to initialize ([initialization](#initialization))
*	`ansible/variables/*` : all other files here are generated from `variables.sh`

#### Initialization

*	files ending in `.example` are examples of configuration files and should be replaced with files containing actual values, and without `.example`
	*	list :
		*	`./ansible/variables/variables-credentials.secret.sh.example` 
		*	`./scripts/variables.secret.sh.example` 
		*	`./scripts/analyzer/analyzer.secret.sh.example`
		*	`./terraform/terraform.auto.tfvars.example`
		*	`./terraform/checker/terraform.auto.tfvars.example`
*	files in the format `NAME.generated.EXTENSION` are automatically generated by scripts
	*	e.g.: `variables.generated.yml` is generated by `launch-ansible.sh`, starting from a single `variables.sh` file;


### Output

All outputs and logs are stored in the `out/` directory.  
An example of how they look like, their directories structure, as well as additional outputs, can be found at: https://github.com/papum20/unibo__projects__unibo-SAFARI-outputs.git.  


#### ansible output

The output of the filechecker follows this hierarchy:
*	ransomware name (e.g. [out/ansible/Ransomware.WannaCry/](https://github.com/papum20/unibo__projects__unibo-SAFARI-outputs/tree/master/ansible/Ransomware.WannaCry)) - subfolder automatically created from the exact name of the ransomware executable/archive;
*	some name to specify the kind of test (e.g. [out/ansible/Ransomware.WannaCry/1s-5shards/](https://github.com/papum20/unibo__projects__unibo-SAFARI-outputs/tree/master/ansible/Ransomware.WannaCry/1s-5shards/)) - either created manually, or through scipts such as `test-ransomware.sh`;  
*	IP address of the VM that filechecker was run on;
*	full hierarchy of the path containing all the outputs on the VM (by default, each filechecker VM stores the output directory in `/home/checker/`);
*	test folder, automatically named as a timestamp.

The timestamp naming assures that, even if the same VM was to execute more tests, these would display as different output directories (i.e. timestamps), although inside the same IP directory.  

More in detail, each output folder contains these files:
*	`cleanWindowsChecksum` : checksum created through a ranflood snapshot, before an attack (on the infected VM)
*	`log_daemon<TIMESTAMP_INFECTED>.txt` : log of the ranflood daemon (on the infected VM), during the attack
*	`log<TIMESTAMP_INFECTED>.txt` : log of the ansible playbook run internally, on the infected VM, during the attack
*	`log<TIMESTAMP_CHECKER>.txt` : log of the filechecker, during the check/restore command execution
*	`out<TIMESTAMP_CHECKER>.txt` : terminal output of the filechecker's check/restore command
*	`report-shards<TIMESTAMP_CHECKER>` : additional report generated by the filechecker's restore command, containing info on created and corrupted SSS shards
*	`report<TIMESTAMP_CHECKER>` : final report generated by the filechecker's check/restore command

A `timestamp` is generated at each execution of the `launch.sh` or `launch-ansible.sh` command (namely by `generate.sh`) - either in infected or checker mode -, thus:
*	the timestamp naming the folder is that of the filechecker
*	`TIMESTAMP_INFECTED` and `TIMESTAMP_CHECKER` are always different (and the infected one comes first)


### Troubleshooting

*	often, terraform will fail to write a VM's info (missing IP or ID, or a MAC address in the place of the IP) on the output file `vm.txt` :
	*	option 1 : ignore the error and run everything again
		*	note: scripts such as `launch-both.sh`, `launch-both-retry.sh` and `test-ransomware.sh` already do repeated tests automatically
	*	option 2 : retry `./scripts/launch.sh -d`
	*	option 3 : manually edit `vm.txt` (with the actual values) and launch `./scripts/launch.sh -m`
*	`Ranflood 0.7-beta` will throw an error for missing `vcruntime140_1.dll` : run the installer from https://learn.microsoft.com/it-it/cpp/windows/latest-supported-vc-redist?view=msvc-170
	*	note: it's already installed on the VM templates we used
*	Error in ansible (checker) :  
	```
	fatal: [192.168.2.235]: FAILED! => {"msg": "to use the 'ssh' connection type with passwords or pkcs11_provider, you must install the sshpass program"}
	```
	Install `sshpass` :  
	```
	sudo apt install sshpass
	```
