-- 请先在shell脚本下导入新项目的sql文件
-- mysql
delete from yjy_ad;
delete from yjy_admin_attach;
delete from yjy_feedback;
delete from yjy_message;
delete from yjy_question_comment;
delete from yjy_question_count;
delete from yjy_question_feedback;
delete from yjy_question_log;
delete from yjy_sendsms;
delete from yjy_temp_answer;
delete from yjy_unlock;
delete from yjy_user_0;
delete from yjy_user_admin;
delete from yjy_user_ban;
delete from yjy_user_login;
delete from yjy_user_oauth;
drop table yjy_answer_user_0;
drop table yjy_collection_user_0;
drop table yjy_note_user_0;
drop table yjy_question_comment_info_0;
GRANT USAGE ON *.* TO 'edu'@'localhost' IDENTIFIED BY '#GI4qfo7xK11';
GRANT ALL PRIVILEGES ON `yjy_edu`.* TO 'edu'@'localhost';
GRANT USAGE ON *.* TO 'edu'@'192.168.199.161' IDENTIFIED BY '#GI4qfo7xK11';
GRANT ALL PRIVILEGES ON `yjy_edu`.* TO 'edu'@'192.168.199.161';
flush privileges;
quit

