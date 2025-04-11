<img style="float:right;" src="icon.png?raw=true" width="25%">

# SAFARI
The Scalable Air-gapped Framework for Automated Ransomware Investigation (SAFARI) platform

## Disclaimers

This project works with ransomwares, stored locally (usually zipped and protected by a password), transferred to the target machine, unzipped and executed there (optionally after disabling network interfaces).  
Launching the ansible playbooks through `launch-ansible.sh` optionally downloads a zipped ransomware.  

## Usage

1.	initialize the configuration (refer to [initialization](#initialization));
2.	you can use the provided scripts; here are the main ones, from the most automated one to the most detailed one (refer to their own section below) :
	*	[group-tests.sh](#group-tests.sh) : 
	*	[launch-both-retry.sh](#launch-both-retry.sh) :
	*	[launch-both.sh](#launch-both.sh) :
	*	[launch.sh](#launch.sh) :


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

##### group-tests.sh

##### group-uploads.sh

##### launch-both-retry.sh
Like [launch-both.sh](#launch-bothsh), but retry until the specified number of tests has been completed successfully; e.g.:  
```bash
./scripts/launch-both-retry.sh 10
```

##### launch-both.sh
Basically (plus some setup) :
```bash
./scripts/launch.sh
./scripts/launch.sh -c
```

Optionally, run more tests with the current setup; e.g.:
```bash
./scripts/launch-bot.sh 10
```

##### launch.sh
```
./scripts/launch.sh [--c|-checker] [-d|--delete] [-D|--destroy] [-l LOG_FILE] [-h|--help]"
```
Launch the terraform provisioner (before) and the ansible playbooks (after), on the remote hosts, either for:
*	target VM : destroy previous VMs, create new ones and launch the tests, with ansible, on them; also, will update checker's terraform variables with the disks to check :
	```bash
	./scripts/launch.sh
	```
*	filechecker : run the filechecker, on the infected disks :
	```bash
	./scripts/launch.sh -c
	```

Each (of the two) terraform provisioner will create, in its directory, a `vm.txt` file, containing the information about the created VMs (IPs, IDs, disks for the infected ones).  

Other parameters:
*	`-d` : delete after
*	`-D` : delete only
*	`-l LOG_FILE` : log to file
*	`-m` : manual mode, i.e. don't provision with terraform (destroy and recreate) (also refer to [troubleshooting](#troubleshooting))


##### auxiliary & implementative scripts
*	`./scripts/generate.sh` : auto-generate variables files
*	`./scripts/launch_workaround.sh` : like `launch.sh`, but with a workaround for some old bugs, which have been probably been fixed now.  
*	`./scripts/read-vms.sh` : read data of the VMs generated with SAFARI's terraform scripts, and export them as variables


#### analyzer

Basically, to upload a full ransomware's folder, with the checksum in `./scripts/analyzer/cleanWindowsChecksum_filtered.json`, use :
```bash
./scripts/analyzer/upload-one.sh LOCAL_FOLDER_PATH REMOTE_FOLDER_NAME RANSOMWARE
```

*	`./scripts/analyzer/cleanWindowsChecksum*` : a checksum is required for the analyzer scripts; this is the one used in these tests, but could be changed
*	`./scripts/analyzer/cleanWindowsChecksum.json` : the base one
*	`./scripts/analyzer/cleanWindowsChecksum_filtered.json` : with some filters
*	`./scripts/analyzer/cleanWindowsChecksum_no_appdata.json` : removed `AppData`
*	`./scripts/analyzer/convert*.py` : example scripts used to filter the checksum
*	`./scripts/analyzer/upload-one.sh` : upload a full ransomware's folder
*	`./scripts/analyzer/upload-all.sh` : examples of uploading multiple ransomwares (old)
*	`./scripts/analyzer/upload.sh` : upload a single file

#### python

*	`./scripts/python/average.py` : calculate averages and stats, from the detailed SSS reports
*	`./scripts/python/report-flatten-filter.py` : process an SSS report so that it can be used by the analyzer

#### util

`ssh` and `scp` scripts only work with 1 VM, reading its info from the appropriate `vm.txt` file.  

*	`.scripts/util/out-count-results.sh` : count checker results (report files) in the specified folder, not recursive (i.e. search the files recursively in all and only subfolders, of the specified one, in the form of an IP)
*	`.scripts/util/ssh-checker-check.sh` : launch an internal check in checker
*	`.scripts/util/ssh-checker.sh` : ssh in checker
*	`.scripts/util/ssh-scp-checker-out.sh` : scp from checker
*	`.scripts/util/ssh-scp-checker-to.sh` : scp to checker
*	`.scripts/util/ssh-windows.sh` : ssh in windows
*	`./scripts/util/vm-status.sh` : change proxmox vm status (through API)


### Configuration

*	`ansible/variables/variables_[external|internal].yml` : external/internal playbook
*	`ansible/variables/variables.sh` : most of ansible variables
*	`ansible/variables/*` : most of these are generated from `variables.sh`
*	`scripts/variables.secret.sh` : variables for scripts  

#### Initialization

*	files ending in `.example` are examples of configuration files and should be replaced with actual values, and without `.example`;
	*	list :
		*	`./ansible/variables/variables-credentials.secret.sh.example` 
		*	`./scripts/variables.secret.sh.example` 
		*	`./scripts/analyzer/analyzer.secret.sh.example`
		*	`./terraform/terraform.auto.tfvars.example`
		*	`./terraform/checker/terraform.auto.tfvars.example`
*	files in the format `NAME.generated.EXTENSION` are automatically generated by scripts, e.g. `variables.generated.yml` is generated by `launch-ansible.sh`, starting from a single `variables.sh` file;


### Output

### Troubleshooting

*	Terraform doesn't execute provider completely, so `vm.txt` doesn't contain the VM's ip or id:
	either retry `./scripts/launch.sh -d` or manually edit `vm.txt` and launch `./scripts/launch.sh -m`
*	When launching ansible alone, if the playbook is stuck on some hosts (e.g. `windows` group), it may be due to the fact that their network interfaces were disabled previously by the playbook: connect from proxmox or recreate them.  
*	Ranflood 0.7-beta will throw an error for missing `vcruntime140_1.dll` : run the installer from https://learn.microsoft.com/it-it/cpp/windows/latest-supported-vc-redist?view=msvc-170
*	Error in ansible (checker) :  
	```
	fatal: [192.168.2.235]: FAILED! => {"msg": "to use the 'ssh' connection type with passwords or pkcs11_provider, you must install the sshpass program"}
	```
	Install `sshpass` :  
	```
	sudo apt install sshpass
	```

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
	*	`out/` : filechecker outputs (refer to [output](#output))
	*	`playbooks/` : example playbooks for some uses
		*	`tasks/` : lists of tasks used in the (external) playbooks
	*	`variables/` : variables (refer to [configuration](#configuration))
	*	`full_playbook.yml` : playbook run on this machine
	*	`internal_playbook_java.yml` : like `internal_playbook.yml`, but with the java version of ranflood
	*	`internal_playbook.yml` : playbook transferred and run on the target machines
*	`out/` : outputs and logs (refer to [output](#output))
*	`scripts/` : scripts to launch the project or interact with the rig, proxmox etc. (refer to [scripts](scripts))
*	`terraform/` : terraform scripts to deploy the infrastructure
	*	`checker/` : checker scripts

