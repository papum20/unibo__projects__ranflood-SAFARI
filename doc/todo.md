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
		*	1s 5shards - 10
	*	just too fast, no matter #shards :
		*	always 0 restored (and not already existing)
		*	always 100-800 shards corrupted
		*	probably corrupts a shard as soon as it gets created!
*	wannacry
	*	old (don't know if used sss improvement)
		*	1s 200shards - 10 (res 10)
	*	sss improvement (no split corrupted files)
		*	60s 200shards - 5 (res 10)
		*	1s 200shards - 2 (res 10) doing
		*	1s 10shards - 5 (res 60)
		*	1s 5shards - 10 (res 75)
		*	1s 50shards - 4 (res 20)
*	phobos
	*	sss improvement (no split corrupted files)
		*	1s 5shards - 3 (res 0, ransomware doesn't activate)

## DONE	

*	filechecker :
	*	count shards corrupted vs originals corrupted
