# Windows commands

`wmic process where "name='java.exe'" get Commandline,Processid` :  find processes info where name is `java.exe`  
`tasklist` : ps  
`tasklist /v` : ps -v  
`taskkill /F /PID <PID>` : kill  
```bash
ansible-playbook -vvv -i /mnt/c/Users/internal_inventory /mnt/c/Users/internal_playbook.yml --extra-vars "@/mnt/c/Users/variables.generated.yml" --extra-vars "@/mnt/c/Users/variables_internal.yml" ^> /mnt/c/Users/log20250103-15_24_15.txt 2^>^&1
```
```bash
sshpass -pPassw0rd! ssh IEUser@192.168.2.
```