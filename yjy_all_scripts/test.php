<?php
	$arr = array('fifo','char','dir','block','link','file','socket','others');
	for($i=0;$i<count($arr);$i++){
		$arr[$i]=array();
		var_dump($arr[$i]);
	}
        var_dump($fifo)
?>
