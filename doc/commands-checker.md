# Commands checker

```bash
rm log* out* report* -f && \
	java -Xmx5G -jar "/home/checker//filechecker.jar" "restore" "--debug" "--dry-run" "-l=/home/checker/log.txt" "-e=/mnt/win10/Users/IEUser/AppData" \
	"--windows-letter=C" "-w=/mnt/win10/" \
	"/home/checker/cleanWindowsChecksum" "/home/checker/report-shards" "/home/checker/report" "/mnt/win10/Users/IEUser" \
	> out.txt 2>&1
```
```bash
sshpass -pchecker ssh -o StrictHostKeyChecking=no checker@192.168.2.
```
```bash
sshpass -pchecker scp -o StrictHostKeyChecking=no checker@192.168.2.:~/{report*,out*,log*} out
```
