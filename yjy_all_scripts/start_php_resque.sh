#! /usr/bin/env bash
#! 模考队列开机自动启动脚本
cd /www/web/php-resque/demo
QUEUE=PostAnswerPharmic COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_pharmic.php
QUEUE=AnalysisAnswerPharmic COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_pharmic.php

QUEUE=PostAnswerXiyizonghe COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_xiyizonghe.php
QUEUE=AnalysisAnswerXiyizonghe COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_xiyizonghe.php

QUEUE=PostAnswerZhongyizonghe COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_zhongyizonghe.php
QUEUE=AnalysisAnswerZhongyizonghe COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_zhongyizonghe.php



QUEUE=PostAnswerEdu COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_edu.php
QUEUE=AnalysisAnswerEdu COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_edu.php

QUEUE=PostAnswerLawmaster COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_lawmaster.php
QUEUE=AnalysisAnswerLawmaster COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_lawmaster.php

QUEUE=PostAnswerPsychology COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_psychology.php
QUEUE=AnalysisAnswerPsychology COUNT=2 INTERVAL=0 REDIS_BACKEND=127.0.0.1:6389 REDIS_BACKEND_DB=1 php resque_psychology.php

