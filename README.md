# Git
### Basics
- add [files]
- commit
	- -m 'message'
- push
- pull
### Show Info
- status
- diff
- log
	- --pretty=oneline
	- -- graph
- reflog
- reset --hard HEAD^
- restore
### Branch
- branch
	- list all branch
	- -b: delete branch
- switch 
	- -c: create and switch
- merge 
	- -m 'message'
- stash 
	- list
	- pop
### sshkey
```
ssh-keygen -t rsa -C "xxx@xxx.com"
```
```
cat ~/.ssh/id_rsa.pub
```
copy to github-setting-ssh
### Remote
- remote set-url origin [github url]
### config
- alias.[name] [cmd]
