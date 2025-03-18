# TODO

*	tests :
	*	exfiltration mode
	*	sss: ignore desktop.ini
	*	retry 60s w/ sss improvement (no split corrupted files)

## DOING

*	tests :
	*	new ransomware instead of useless vipasana, phobos

*	lockbit
	*	sss improvement (no split corrupted files)
		*	1s 200shards - 10
		*	1s 10shards - 5
		*	1s 5shards - 5
		*	1s 50shards - 
	*	just too fast, no matter #shards :
		*	always 0 restored (and not already existing)
		*	always 100-800 shards corrupted
		*	probably corrupts a shard as soon as it gets created!
*	wannacry
	*	sss improvement (no split corrupted files)
		*	1s 200shards - 10 (res 10)
		*	1s 10shards - 5 (res 60)
		*	1s 5shards - 3 (res 75)
		*	1s 50shards - 4 (res 20)

## DONE	

*	filechecker :
	*	count shards corrupted vs originals corrupted
